# app/controllers/dashboard/landing_page_controller.rb
class Dashboard::LandingPageController < DashboardController # Or ApplicationController
  # before_action :authenticate_user! # Assuming Devise or similar
  # Add authorization check here if needed (e.g., Pundit, CanCanCan, or a simple check)
  # before_action :ensure_user_is_admin_or_seller

  def index
    # Fetch data for the dashboard overview
    @total_orders = Order.count
    @total_products = Product.count
    @total_users = User.count
    @total_revenue = Order.sum(:total_price) # Adjust column name if needed

    # Fetch recent orders (limit to 5)
    @recent_orders = Order.includes(:user).order(created_at: :desc).limit(5)

    # Fetch low stock products (example threshold: 5)
    @low_stock_products = Product.where('stock_quantity <= ?', 5).order(:stock_quantity).limit(5)

    # Example: Fetch top selling products (by quantity sold)
    # This assumes you have an 'order_items' table linking orders to products
    # and a 'quantity' column in 'order_items'.
    # @top_selling_products = Product.joins(:order_items)
    #                               .group('products.id')
    #                               .order('SUM(order_items.quantity) DESC')
    #                               .limit(5)
  end
end