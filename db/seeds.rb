# db/seeds/clothing_recommendation_data.rb
require 'securerandom'

puts "👗 Seeding fashion store data (no Stripe, no callbacks)..."

# Compliant password: meets your validation rules
DUMMY_PASSWORD = "Password123!"  # upper, lower, number, special, 12 chars

# --- Clothing Products ---
CLOTHING_PRODUCTS = [
  { name: "Relaxed Fit Cotton T-Shirt", category: "Tops", color: "White", size: "M" },
  { name: "Slim Fit Denim Jeans", category: "Bottoms", color: "Blue", size: "32" },
  { name: "Oversized Hoodie", category: "Outerwear", color: "Black", size: "L" },
  { name: "Floral Summer Dress", category: "Dresses", color: "Multicolor", size: "S" },
  { name: "Cargo Pants", category: "Bottoms", color: "Khaki", size: "34" },
  { name: "Knit Sweater", category: "Tops", color: "Beige", size: "M" },
  { name: "Leather Jacket", category: "Outerwear", color: "Brown", size: "L" },
  { name: "Striped Polo Shirt", category: "Tops", color: "Navy", size: "M" },
  { name: "High-Waisted Leggings", category: "Bottoms", color: "Black", size: "S" },
  { name: "Linen Button-Up Shirt", category: "Tops", color: "White", size: "L" },
  { name: "Winter Puffer Jacket", category: "Outerwear", color: "Black", size: "M" },
  { name: "Maxi Skirt", category: "Bottoms", color: "Floral", size: "M" },
  { name: "Graphic Print T-Shirt", category: "Tops", color: "Gray", size: "L" },
  { name: "Chino Shorts", category: "Bottoms", color: "Beige", size: "32" },
  { name: "Wool Blend Coat", category: "Outerwear", color: "Camel", size: "M" }
]

# Create categories
categories = {}
CLOTHING_PRODUCTS.map { |p| p[:category] }.uniq.each do |cat_name|
  categories[cat_name] = Category.find_or_create_by!(name: cat_name) do |c|
    c.description = "#{cat_name} for everyday style"
    c.featured = false
  end
end

# Create products
clothing_products = CLOTHING_PRODUCTS.map.with_index do |attrs, idx|
  Product.find_or_create_by!(id: 2000 + idx) do |p|
    p.name = attrs[:name]
    p.description = "#{attrs[:name]} in #{attrs[:color]}. Premium quality, comfortable fit."
    p.published = true
    p.featured = [true, false].sample
    p.stock_quantity = rand(20..150)
    p.category = categories[attrs[:category]]
  end
end

# --- User Profiles ---
user_profiles = [
  { name: "Sophie", city: "Paris", country: "FR" },
  { name: "James", city: "London", country: "UK" },
  { name: "Aisha", city: "Dubai", country: "AE" },
  { name: "Liam", city: "New York", country: "US" },
  { name: "Mei", city: "Tokyo", country: "JP" },
  { name: "Elena", city: "Milan", country: "IT" },
  { name: "David", city: "Berlin", country: "DE" },
  { name: "Zara", city: "Mumbai", country: "IN" }
]

# Create users WITHOUT triggering callbacks (safe for dev/seeds)
real_users = user_profiles.map.with_index do |profile, idx|
  email = "#{profile[:name].downcase}#{idx + 1}@example.com"
  
  # Skip callbacks entirely (no cart? we'll create it manually if needed)
  user = User.find_by(email: email)
  unless user
    user = User.new(
      email: email,
      first_name: profile[:name],
      last_name: "Shopper",
      city: profile[:city],
      country: profile[:country],
      password: DUMMY_PASSWORD,
      role: 0,
      address_line1: "123 Fashion Street",
      postal_code: "10001"
    )
    # Save without callbacks (avoids cart creation too, but we'll handle orders directly)
    User.skip_callback(:create, :after, :ensure_cart_exists) if User._create_callbacks.any? { |c| c.method == :ensure_cart_exists }
    user.save!(validate: false) # skip validations that might depend on callbacks
    User.set_callback(:create, :after, :ensure_cart_exists) if User._create_callbacks.none? { |c| c.method == :ensure_cart_exists }
  end
  user
end

# --- User Interactions (views, purchases) ---
INTERACTIONS = [
  [0, 0, "view"], [0, 1, "view"], [0, 0, "purchase"], [0, 1, "purchase"],
  [1, 2, "view"], [1, 7, "view"], [1, 7, "purchase"], [1, 2, "purchase"],
  [2, 3, "view"], [2, 11, "view"], [2, 3, "purchase"], [2, 11, "purchase"],
  [3, 2, "view"], [3, 12, "view"], [3, 2, "purchase"], [3, 12, "purchase"],
  [4, 9, "view"], [4, 13, "view"], [4, 9, "purchase"], [4, 13, "purchase"],
  [5, 3, "view"], [5, 6, "view"], [5, 3, "purchase"], [5, 6, "purchase"],
  [6, 0, "view"], [6, 1, "view"], [6, 0, "purchase"],
  [7, 3, "view"], [7, 11, "view"], [7, 3, "purchase"]
]

puts "→ Creating user interactions..."
INTERACTIONS.each do |user_idx, prod_idx, type|
  score = type == "purchase" ? 3.0 : 1.0
  UserInteraction.find_or_create_by!(
    user: real_users[user_idx],
    product: clothing_products[prod_idx],
    interaction_type: type
  ) { |ui| ui.score = score }
end

# --- Orders & OrderItems ---
puts "→ Creating orders..."
INTERACTIONS.select { |_, _, t| t == "purchase" }.group_by(&:first).each do |user_idx, purchases|
  user = real_users[user_idx]
  order = Order.find_or_create_by!(
    user: user,
    status: "completed",
    payment_status: "paid",
    paid_at: Time.current - rand(1..14).days,
    checkout_session_id: "cs_seed_#{SecureRandom.hex(8)}",
    email: user.email,
    first_name: user.first_name,
    last_name: user.last_name,
    country: user.country,
    city: user.city,
    address: user.address_line1,
    postal_code: user.postal_code,
    shipping_cost: 4.99,
    tax: 3.20
  )

  total = 0
  purchases.each do |_, prod_idx, _|
    product = clothing_products[prod_idx]
    base_price = case product.category.name
                 when "Dresses" then rand(35..70)
                 when "Outerwear" then rand(60..120)
                 else rand(15..45)
                 end
    price = base_price.round(2)
    total += price

    OrderItem.find_or_create_by!(
      order: order,
      product: product,
      quantity: 1,
      price: price,
      size: CLOTHING_PRODUCTS[prod_idx][:size],
      color: CLOTHING_PRODUCTS[prod_idx][:color]
    )
  end

  order.update_column(:total_price, (total + order.shipping_cost + order.tax).round(2))
end

# --- Fallback Recommendations (for guest users) ---
puts "→ Creating fallback recommendations..."
FALLBACK_PAIRS = [[0,1], [1,0], [2,12], [3,11], [7,2], [9,13]]
FALLBACK_PAIRS.each do |i, j|
  ProductRecommendation.find_or_create_by!(
    product: clothing_products[i],
    recommended_product: clothing_products[j]
  ) do |r|
    r.confidence = rand(0.7..0.92).round(3)
    r.support = rand(0.4..0.65).round(3)
    r.score = r.confidence * r.support
  end
end

puts "✅ Fashion store seed data loaded successfully!"
puts "💡 Test: ItemBasedRecommendationService.new(User.first).get_recommendations(Product.find(2000))"