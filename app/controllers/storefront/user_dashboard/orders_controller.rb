# app/controllers/storefront/user_dashboard/orders_controller.rb
class Storefront::UserDashboard::OrdersController < ApplicationController # Or ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.page(params[:page]).per(10)

    # Add pagination if needed: @orders = current_user.orders.order(created_at: :desc).page(params[:page])
  end

  def show
    # @order = current_user.orders.find(params[:id])
   
    @order = current_user.orders
                      .includes(order_items: [:product, :variant])
                      .find(params[:id])

    # Eager load order items and products for efficiency
    # @order = current_user.orders.includes(order_items: :product).find(params[:id])
  end
end