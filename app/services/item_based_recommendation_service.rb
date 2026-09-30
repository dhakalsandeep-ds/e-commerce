# app/services/item_based_recommendation_service.rb
class ItemBasedRecommendationService
  def initialize(user = nil, similarity_method = 'cosine')
    @user = user
    @similarity_method = similarity_method
  end

  def get_recommendations(product, limit: 3)
    if @user
      calculate_item_based_recommendations(product, limit)
    else
      get_apriori_recommendations(product, limit)
    end
  end

  private

  def calculate_item_based_recommendations(product, limit)
    user_interactions = get_combined_user_interactions
    user_product_ids = user_interactions.map { |i| i[:product_id] }.uniq
    
    similar_products = get_similar_products_from_history(user_product_ids, product)
    
    recommendations = []
    similar_products.each do |product_data|
      candidate_product = Product.find_by(id: product_data[:product_id])
      next unless candidate_product
      
      score = calculate_similarity_score(product_data[:product_id], product.id)
      
      recommendations << ProductRecommendation.new(
        recommended_product: candidate_product,
        confidence: score,
        support: product_data[:co_interaction_count],
        score: score * product_data[:co_interaction_count]
      )
    end
    
    recommendations.sort_by { |r| -r.confidence }.first(limit)
  end

  def get_combined_user_interactions
    interactions = []
    
    if @user
      # Get UserInteraction data
      UserInteraction.for_user(@user).each do |ui|
        interactions << {
          product_id: ui.product_id,
          type: ui.interaction_type,
          weight: ui.score
        }
      end
      
      # Get OrderItem data
      OrderItem.joins(:order)
               .where(orders: { user_id: @user.id })
               .each do |order_item|
        interactions << {
          product_id: order_item.product_id,
          type: 'purchase',
          weight: 3.0
        }
      end
    end
    
    interactions
  end

  def get_similar_products_from_history(user_product_ids, current_product)
    # Get from UserInteraction
    interaction_similar = UserInteraction
      .where(product_id: user_product_ids)
      .pluck(:user_id)
      .uniq
    
    interaction_products = UserInteraction
      .where(user_id: interaction_similar)
      .where.not(product_id: user_product_ids + [ current_product.id ])
      .group(:product_id)
      .select('product_id, COUNT(*) as co_interaction_count')
      .order('co_interaction_count DESC')
      .limit(25)
    
    # Get from OrderItem
    order_similar = OrderItem
      .joins(:order)
      .where(product_id: user_product_ids)
      .pluck(:order_id)
      .uniq
    
    order_products = OrderItem
      .joins(:order)
      .where(orders: { id: order_similar })
      .where.not(product_id: user_product_ids + [ current_product.id ])
      .group(:product_id)
      .select('product_id, COUNT(*) as co_purchase_count')
      .order('co_purchase_count DESC')
      .limit(25)
    
    # Combine both
    combined_products = {}
    interaction_products.each do |p|
      combined_products[p.product_id] = p.co_interaction_count
    end
    
    order_products.each do |p|
      combined_products[p.product_id] = (combined_products[p.product_id] || 0) + p.co_purchase_count
    end
    
    # Use hash instead of OpenStruct
    combined_products.map do |product_id, count|
      { product_id: product_id, co_interaction_count: count }
    end.sort_by { |p| -p[:co_interaction_count] }.first(20)
  end

  def calculate_similarity_score(product1_id, product2_id)
    # Get users who interacted with each product
    users_with_product1 = get_all_users_for_product(product1_id)
    users_with_product2 = get_all_users_for_product(product2_id)
    
    case @similarity_method
    when 'jaccard'
      calculate_jaccard_similarity(users_with_product1, users_with_product2)
    when 'cosine'
      calculate_cosine_similarity(users_with_product1, users_with_product2)
    when 'pearson'
      calculate_pearson_correlation(product1_id, product2_id)
    else
      calculate_jaccard_similarity(users_with_product1, users_with_product2)
    end
  end

  def get_all_users_for_product(product_id)
    # Get users from both sources
    interaction_users = UserInteraction.where(product_id: product_id).pluck(:user_id).to_set
    order_users = OrderItem.joins(:order).where(product_id: product_id).pluck(:user_id).to_set
    
    interaction_users | order_users  # Union of both sets
  end

  def calculate_jaccard_similarity(set1, set2)
    intersection = (set1 & set2).size.to_f
    union = (set1 | set2).size
    return 0.0 if union == 0
    intersection / union
  end

  def calculate_cosine_similarity(set1, set2)
    intersection = (set1 & set2).size.to_f
    magnitude1 = set1.size.to_f
    magnitude2 = set2.size.to_f
    return 0.0 if magnitude1 == 0 || magnitude2 == 0
    intersection / (Math.sqrt(magnitude1 * magnitude2))
  end

  def calculate_pearson_correlation(product1_id, product2_id)
    users_with_product1 = get_all_users_for_product(product1_id)
    users_with_product2 = get_all_users_for_product(product2_id)
    
    common_users = users_with_product1 & users_with_product2
    return 0.0 if common_users.size < 2
    
    # Simplified Pearson for binary data
    n = common_users.size.to_f
    numerator = n * common_users.size - users_with_product1.size * users_with_product2.size
    denominator = Math.sqrt((n * users_with_product1.size - users_with_product1.size ** 2) * 
                           (n * users_with_product2.size - users_with_product2.size ** 2))
    
    return 0.0 if denominator == 0
    numerator / denominator
  end

  def get_apriori_recommendations(product, limit)
    ProductRecommendation
      .where(product: product)
      .includes(:recommended_product)
      .order(confidence: :desc, support: :desc)
      .limit(limit)
  end
end