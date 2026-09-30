# lib/tasks/kmeans.rake
namespace :customers do
  desc "Run KMeans segmentation and save customer_group names"
  task segment: :environment do
    puts "Running KMeans segmentation..."
    result = KMeansSegmenter.new(k: 5).run!(persist: true)
    if result[:error]
      puts "Error: #{result[:error]}"
    else
      puts "KMeans completed!"
      puts "Inertia: #{result[:inertia].round(2)}"
      User.group(:customer_group).count.each do |group, count|
        puts "#{group}: #{count} users"
      end
    end
  end
end
