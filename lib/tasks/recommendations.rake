namespace :recommendations do
  desc "Generate Apriori-based recommendations"
  task apriori: :environment do
    puts "Generating Apriori recommendations..."
    start_time = Time.current
    
    AprioriService.generate_recommendations
    
    duration = Time.current - start_time
    puts "✅ Apriori recommendations generated in #{duration.round(2)} seconds!"
    
    # Show stats
    total_recs = ProductRecommendation.count
    puts "📊 Generated #{total_recs} Apriori recommendations"
    
    if total_recs > 0
      avg_confidence = ProductRecommendation.average(:confidence)
      puts "📈 Average confidence: #{(avg_confidence * 100).round(2)}%"
    end
  end

  desc "Show recommendation statistics"
  task stats: :environment do
    apriori_count = ProductRecommendation.count
    avg_confidence = ProductRecommendation.average(:confidence) || 0
    
    puts "📊 Recommendation Statistics:"
    puts "Apriori recommendations: #{apriori_count}"
    puts "Average confidence: #{(avg_confidence * 100).round(2)}%"
    puts ""
    puts "Note: Item-based recommendations calculated in real-time"
  end
end