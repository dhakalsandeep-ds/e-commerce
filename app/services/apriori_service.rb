class AprioriService
  # Minimum thresholds (adjust based on your dataset size)
  MIN_SUPPORT = 0.0    # 1% of total orders
  MIN_CONFIDENCE = 0.0  # 50% confidence

  def self.generate_recommendations
    ProductRecommendation.delete_all
    
    # Get total number of orders for support calculation
    total_orders = Order.count.to_f
    min_support_count = (total_orders * MIN_SUPPORT).ceil

    # Only process if we have enough data
    return if total_orders < 10

    Product.find_each do |product_a|
      # Find orders containing product_a
      orders_with_a = OrderItem.joins(:order)
        .where(order_items: { product_id: product_a.id })
        .pluck(:order_id)

      next if orders_with_a.size < min_support_count

      # Calculate support for product_a
      support_a = orders_with_a.size / total_orders

      # Find co-purchased products
      co_purchased = OrderItem.joins(:order)
        .where(orders: { id: orders_with_a })
        .where.not(product_id: product_a.id)
        .group(:product_id)
        .count

      co_purchased.each do |product_b_id, co_count|
        next if co_count < min_support_count

        # Calculate support for (A ∪ B)
        support_ab = co_count / total_orders

        # Calculate confidence: P(B|A) = support(A ∪ B) / support(A)
        confidence = support_ab / support_a

        # Only create recommendation if meets thresholds
        if confidence >= MIN_CONFIDENCE
          ProductRecommendation.create!(
            product: product_a,
            recommended_product_id: product_b_id,
            score: co_count.to_d,
            support: support_ab.to_d,
            confidence: confidence.to_d
          )
        end
      end
    end
  end
end