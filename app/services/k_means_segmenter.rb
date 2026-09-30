class KMeansSegmenter
  SEGMENT_NAMES = ["VIP", "Loyal", "New", "At-Risk", "Low Value"] # meaningful names

  def initialize(k: 5, max_iter: 100, normalize: true, scope: User.all)
    @k = k.to_i
    @max_iter = max_iter
    @normalize = normalize
    @scope = scope
  end

  def run!(persist: true)
    features, users = build_feature_matrix_sql
    return { error: "no users" } if features.empty?

    features, @means, @stds = normalize(features) if @normalize

    labels, centroids, inertia = kmeans(features, @k, @max_iter)

    # Determine cluster ordering based on average total_spent (descending)
    cluster_totals = Array.new(@k, 0.0)
    cluster_counts = Array.new(@k, 0)

    users.zip(labels).each_with_index do |(user, label), i|
      total_spent = features[i][2] # monetary
      cluster_totals[label] += total_spent
      cluster_counts[label] += 1
    end

    # Compute cluster rank (highest total_spent => VIP, etc.)
    cluster_avg = cluster_totals.each_with_index.map { |total, idx| [total.to_f / (cluster_counts[idx].positive? ? cluster_counts[idx] : 1), idx] }
    cluster_rank = cluster_avg.sort_by { |avg, idx| -avg }.map(&:last) # descending

    cluster_to_name = {}
    cluster_rank.each_with_index do |cluster_idx, i|
      cluster_to_name[cluster_idx] = SEGMENT_NAMES[i] || "Unknown"
    end

    if persist
      users.zip(labels).each do |user, label|
        user.update_column(:customer_group, cluster_to_name[label] || "Unknown")
      end
    end

    { labels: labels, centroids: centroids, inertia: inertia, cluster_to_name: cluster_to_name }
  end

  private

  def build_feature_matrix_sql
    today = Date.current
    rows = @scope
      .joins("LEFT JOIN orders ON orders.user_id = users.id")
      .joins("LEFT JOIN order_items ON order_items.order_id = orders.id")
      .select(
        "users.*",
        "COUNT(DISTINCT orders.id) AS orders_count",
        "COALESCE(SUM(order_items.price * order_items.quantity),0) AS total_spent",
        "MAX(orders.created_at) AS last_order_at"
      )
      .group("users.id")
      .map do |u|
        last_order_at = u.attributes["last_order_at"]
        recency_days = last_order_at ? (today - last_order_at.to_date).to_i : (365 * 10)
        freq = u.attributes["orders_count"].to_i
        monetary = u.attributes["total_spent"].to_f
        avg_order = freq > 0 ? monetary / freq : 0.0
        features = [recency_days.to_f, freq.to_f, monetary.to_f, avg_order.to_f]
        [features, u]
      end

    features = rows.map(&:first)
    users = rows.map(&:last)
    [features, users]
  end

  def normalize(data)
    cols = data.transpose
    means = cols.map { |c| mean(c) }
    stds = cols.map { |c| stddev(c) }
    norm = data.map do |row|
      row.each_with_index.map { |val, i| stds[i] && stds[i] > 0 ? (val - means[i]) / stds[i] : 0.0 }
    end
    [norm, means, stds]
  end

  def mean(arr); arr.sum.to_f / arr.size; end
  def stddev(arr); m = mean(arr); Math.sqrt(arr.map { |v| (v - m)**2 }.sum / arr.size); end

  def kmeans(data, k, max_iter)
    n = data.length
    dim = data.first.length
    centroids = data.sample(k).map(&:dup)
    labels = Array.new(n, 0) 
  
    max_iter.times do
      changed = false

      # assign step 
      data.each_with_index do |p, i|   
        dists = centroids.map { |c| squared_euclidean(p, c) }
        min_idx = dists.each_with_index.min[1]
        if labels[i] != min_idx
          labels[i] = min_idx
          changed = true
        end
      end

      break unless changed

      # update step
      sums = Array.new(k) { Array.new(dim, 0.0) }
      counts = Array.new(k, 0)
      data.each_with_index do |p, i|
        lab = labels[i]
        counts[lab] += 1
        dim.times { |d| sums[lab][d] += p[d] }
      end

      k.times { |j| centroids[j] = counts[j] > 0 ? sums[j].map { |s| s / counts[j] } : data.sample.dup }
    end

    inertia = data.each_with_index.map { |p, i| squared_euclidean(p, centroids[labels[i]]) }.sum
    [labels, centroids, inertia]
  end

  def squared_euclidean(a, b); a.zip(b).map { |x, y| (x - y)**2 }.sum; end
end
