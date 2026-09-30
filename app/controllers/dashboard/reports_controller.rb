# app/controllers/dashboard/reports_controller.rb
class Dashboard::ReportsController < DashboardController
  before_action :authenticate_user! # Assuming Devise

  def index
    # Set default date range to last 30 days
    @start_date = params[:start_date].presence || 30.days.ago.to_date
    @end_date = params[:end_date].presence || Date.current

    # Fetch data based on filters
    @orders = Order.where(created_at: @start_date..@end_date)
    @products = Product.where(created_at: @start_date..@end_date)

    # Calculate summary statistics
    @total_sales = @orders.sum(:total_price)
    @total_orders = @orders.count
    @avg_order_value = @total_orders > 0 ? (@total_sales / @total_orders) : 0

    # Fetch top selling products
    @top_selling_products = @products.joins(:order_items)
                                    .group('products.id')
                                    .order('SUM(order_items.quantity) DESC')
                                    .limit(5)
                                    .select('products.*, SUM(order_items.quantity) as total_quantity_sold')

    # Fetch recent orders
    @recent_orders = @orders.includes(:user).order(created_at: :desc).page(params[:page]).per(10)

     @sales_trend_data = @orders.group_by_month(:created_at, format: "%b %Y", last: 12).sum(:total_price)

     # Order Status Distribution Data
    @order_status_data = @orders.group(:status).count

  end
end