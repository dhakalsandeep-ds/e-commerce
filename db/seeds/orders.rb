# Create test orders with realistic co-purchase patterns
puts "Creating test orders for recommendations..."

# Get products we'll use for co-purchases
testing_product = Product.find(65)  # "testing" product with 3 variants
nike_shoes = Product.find(33)       # "Nike Shoes" 
sfaafs_42 = Product.find(42)        # "sfaafs" with size variants
sfaafs_43 = Product.find(43)        # "sfaafs" with size variants

# Create test user if needed
user = User.first || User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Create 10 test orders with co-purchase patterns
10.times do |i|
  order = Order.create!(
    user: user,
    first_name: "Test",
    last_name: "User",
    email: "test@example.com",
    address: "123 Test St",
    city: "Test City",
    state: "TS",
    postal_code: "12345",
    country: "United States",
    card_number: "4111111111111111",
    expiration_date: "12/25",
    cvc: "123",
    agree_to_terms: true,
    status: "pending"
  )

  # Pattern 1: testing product + Nike Shoes (frequently bought together)
  if i < 7  # 70% of orders
    order.order_items.create!(
      product: testing_product,
      variant: testing_product.variants.sample,
      quantity: 1,
      price: testing_product.variants.sample.price
    )
    order.order_items.create!(
      product: nike_shoes,
      variant: nike_shoes.variants.first,
      quantity: 1,
      price: nike_shoes.variants.first.price
    )
  end

  # Pattern 2: sfaafs products together (complementary items)
  if i >= 3 && i < 8  # 50% of orders
    order.order_items.create!(
      product: sfaafs_42,
      variant: sfaafs_42.variants.sample,
      quantity: 1,
      price: sfaafs_42.variants.sample.price
    )
    order.order_items.create!(
      product: sfaafs_43,
      variant: sfaafs_43.variants.first,
      quantity: 1,
      price: sfaafs_43.variants.first.price
    )
  end

  # Pattern 3: Just testing product (to create variety)
  if i >= 8
    order.order_items.create!(
      product: testing_product,
      variant: testing_product.variants.sample,
      quantity: 1,
      price: testing_product.variants.sample.price
    )
  end

  puts "Created order #{order.id} with #{order.order_items.count} items"
end

puts "✅ Test orders created successfully!"
puts "Now run: rails recommendations:apriori"