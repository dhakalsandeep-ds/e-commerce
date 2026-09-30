# lib/commands/customer_segmenter_command.rb
# Usage: bin/rails customer_segment:train K=3

require 'kmeans-clusterer'

class CustomerSegmenterCommand < Rails::Command::Base
  desc "Train customer segmentation using K-Means clustering"

  argument :k, type: :numeric, default: 3, desc: "Number of clusters"

  def perform
    k = options[:k] || 3
    puts "Running K-Means customer segmentation with #{k} groups..."

    # Fetch data
    data = User.joins(:orders)
               .select('users.id, COUNT(orders.id) as total_orders, SUM(orders.total_price) as total_spent')
               .group('users.id')
               .map { |u| KMeansClusterer::Point.new([u.total_orders.to_f, u.total_spent.to_f], u.id) }

    if data.empty?
      puts "No customer data available."
      return
    end

    # Run KMeans
    clusters = KMeansClusterer.run(k, data, log: true)

    # Assign group
    clusters.each_with_index do |cluster, index|
      cluster.points.each do |point|
        User.find(point.user_id).update(customer_group: "Group #{index + 1}")
      end
    end

    puts "Customer segmentation completed successfully!"
  end
end
