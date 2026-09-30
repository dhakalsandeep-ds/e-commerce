class Storefront::ProductsController < StorefrontController
  def index
    @categories = Category.all

      products = Product.includes(:category)

    if params[:category_id].present? && params[:category_id] != ''
      products = products.where(category_id: params[:category_id])
    end

    if params[:min_price].present? || params[:max_price].present?
      products = products.joins(:variants)
      products = products.where("variants.price >= ?", params[:min_price].to_f) if params[:min_price].present?
      products = products.where("variants.price <= ?", params[:max_price].to_f) if params[:max_price].present?
      products = products.distinct
    end

    @products = products.joins(:variants)
                      .select("products.*, MIN(variants.price) AS min_variant_price")
                      .group("products.id")

    case params[:sort]&.strip
    when 'price_asc'
      @products = @products.order("min_variant_price ASC")
    when 'price_desc'
      @products = @products.order("min_variant_price DESC")
    when 'name_asc'
      @products = @products.order("products.name ASC")
    when 'name_desc'
      @products = @products.order("products.name DESC")
    else
      @products = @products.order("products.created_at DESC")
    end

    @products = @products.page(params[:page]).per(12)
  end

#   def show
#     @product = Product
#       .with_attached_image
#       .with_attached_thumbnails
#       .with_rich_text_description
#       .includes(:category, variants: { option_values: :option_type })
#       .find(params[:id])

#     # ✅ Safely infer option types from variants
#     @option_types = OptionType
#       .joins(option_values: :variants)
#       .where(variants: { product_id: @product.id })
#       .distinct
#       .includes(option_values: :variants)
#       .to_a # Convert to array to ensure it's never nil

#     # Preload variant images
#     unless @product.variants.empty?
#       @product.variants.with_attached_image.load
#     end

#     # @recommendations =  ProductRecommendation
#     #   .where(product: @product)
#     #   .where('score >= 1')  # At least 1 co-occurrence
#     #   .includes(:recommended_product)
#     #   .order(score: :desc)
#     #   .limit(3) 


#       # Get Apriori recommendations
#   @recommendations = ProductRecommendation
#     .where(product: @product)
#     .includes(:recommended_product)
#     .order(confidence: :desc, support: :desc)
#     .limit(3)

#    # Fallback: If no Apriori recommendations, show popular products
#  if @recommendations.empty?
#     popular_products = OrderItem
#       .joins(:product)
#       .where.not(product_id: @product.id)
#       .group('products.id')
#       .order('COUNT(order_items.id) DESC')
#       .limit(3)
#       .includes(:product)
#       .map(&:product)
    
#     # Create dummy ProductRecommendation objects (no DB save needed)
#     @recommendations = popular_products.map do |product|
#       ProductRecommendation.new(
#         recommended_product: product,
#         confidence: 0.0,
#         support: 0.0,
#         score: 0
#       )
#     end
#   end
    # @recommended_products = fetch_external_recommendations(@product.id)

  #   def show
  # @product = Product.find(params[:id])
  # @option_types = @product.option_types.includes(option_values: :variants)
  
  # Load Apriori recommendations (sorted by confidence)
  # @recommendations = ProductRecommendation
  #   .where(product: @product)
  #   .includes(:recommended_product)
  #   # .where('confidence >= ?', 0.5)  # Minimum 50% confidence
  #   .order(confidence: :desc, support: :desc)
  #   .limit(3)
# end
  # end



 def show
    @product = Product
      .with_attached_image
      .with_attached_thumbnails
      .with_rich_text_description
      .includes(:category, variants: { option_values: :option_type })
      .find(params[:id])



            if current_user
  UserInteraction.create!(
    user: current_user,
    product: @product,
    interaction_type: 'view',
    score: 1.0
  )
end

    @option_types = OptionType
      .joins(option_values: :variants)
      .where(variants: { product_id: @product.id })
      .distinct
      .includes(option_values: :variants)
      .to_a

    unless @product.variants.empty?
      @product.variants.with_attached_image.load
    end  

    if current_user
  UserInteraction.create!(
    user: current_user,
    product: @product,
    interaction_type: 'view',
    score: 1.0
  )
    end

    # Use the combined service
    similarity_method = params[:similarity_method] || 'cosine'
    @recommendations = ItemBasedRecommendationService.new(
      current_user, 
      similarity_method
    ).get_recommendations(@product, limit: 3)

    if @recommendations.empty?
      @recommendations = get_association_rule_recommendations(@product)
    end
  end



  private



  def get_association_rule_recommendations(product)
    popular_products = OrderItem
      .joins(:product)
      .where.not(product_id: product.id)
      .group('products.id')
      .order('COUNT(order_items.id) DESC')
      .limit(3)
      .includes(:product)
      .map(&:product)
    
    popular_products.map do |product|
      ProductRecommendation.new(
        recommended_product: product,
        confidence: 0.0,
        support: 0.0,
        score: 0
      )
    end
  end

  def fetch_external_recommendations(product_id)
    require 'net/http'
    require 'json'
    require 'uri'

    recommender_api_url = "http://localhost:8000/recommend"
    timeout_seconds = 5
    top_n = 4

    begin
      uri = URI(recommender_api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = timeout_seconds
      http.open_timeout = timeout_seconds

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = { product_id: product_id, top_n: top_n }.to_json

      response = http.request(request)

      if response.code == '200'
        data = JSON.parse(response.body)
        recommended_ids = data['recommended_product_ids']
        products_hash = Product.where(id: recommended_ids).index_by(&:id)
        recommended_products = recommended_ids.map { |id| products_hash[id] }.compact
        Rails.logger.info "Fetched #{recommended_products.count} recommendations for product #{product_id}"
        recommended_products
      else
        Rails.logger.warn "API error (#{response.code}): #{response.body}"
        fallback_recommendations(product_id)
      end
    rescue => e
      Rails.logger.error "Recommendation error: #{e.message}"
      fallback_recommendations(product_id)
    end
  end

  def fallback_recommendations(product_id)
    current_product = Product.find_by(id: product_id)
    if current_product&.category
      Product.where(category_id: current_product.category_id)
             .where.not(id: product_id)
             .limit(4)
    else
      Product.limit(4)
    end
  end
end