namespace :customer_segmenter do
  desc "Train K-Means clustering for customer segmentation"
  task train: :environment do
    k = ENV['K']&.to_i || 3
    puts "🚀 Training K-Means with K=#{k}..."

    # --- Load features from users with orders and order_items ---
    users_features = User
      .joins(orders: :order_items)
      .select(
        "users.id, 
         SUM(order_items.price * order_items.quantity) AS total_spent, 
         COUNT(DISTINCT orders.id) AS orders_count"
      )
      .group("users.id")

    if users_features.empty?
      puts "No customer data available."
      next
    end

    # Convert to arrays for K-Means
    feature_vectors = users_features.map do |u|
      [u["total_spent"].to_f, u["orders_count"].to_i]
    end

    # --- Simple K-Means placeholder ---
    # Replace this with your K-Means algorithm or gem
    clusters = Array.new(feature_vectors.size, 0) # assigns all to cluster 0

    # Update user records with cluster assignment
    users_features.each_with_index do |user, idx|
      User.where(id: user.id).update_all(customer_group: clusters[idx])
    end

    puts "✅ Customer segmentation completed!"
  end
end
