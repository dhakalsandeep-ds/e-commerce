# app/controllers/storefront/user_dashboard_controller.rb
class Storefront::UserDashboardsController < ApplicationController # Or ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    # Fetch recent orders for the overview
    @recent_orders = @user.orders.order(created_at: :desc).limit(5)
    # You can add other summary data here (e.g., wishlist items count)
    @order = @user.orders.first
  end
end