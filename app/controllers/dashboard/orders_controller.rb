  class Dashboard::OrdersController < DashboardController
    before_action :set_order, only: [:show, :edit, :update, :destroy]
  
    def index
      # Start with all orders, including user for efficiency
    @orders = Order.includes(:user)

    # Apply status filter if provided
    if params[:status].present? && Order.statuses.key?(params[:status])
      @orders = @orders.where(status: params[:status])
    end

    # Apply sorting
    case params[:sort]
    when 'date_asc'
      @orders = @orders.order(created_at: :asc)
    when 'id_desc'
      @orders = @orders.order(id: :desc)
    when 'id_asc'
      @orders = @orders.order(id: :asc)
    else
      # Default sort: Newest first (by creation date)
      @orders = @orders.order(created_at: :desc)
    end

    # Apply pagination (adjust per page as needed)
    @orders = @orders.page(params[:page]).per(10) # Ensure Kaminari is set up
    end
  
    def show 
@order = Order.includes(:user, order_items: [:product, :variant]).find(params[:id])
    end
  
    def edit
      # e.g. update status or tracking
    end
  
    def update
      if @order.update(order_params)
        redirect_to dashboard_order_path(@order), notice: "Order updated."
      else
        render :edit
      end
    end
  
    def destroy
      @order.destroy
      redirect_to dashboard_orders_path, notice: "Order deleted."
    end
  
    private
  
    def set_order
      @order = Order.find(params[:id])
    end
  
    def order_params
      params.require(:order).permit(:status, :tracking_number, :shipping_cost, :tax)
    end
  end
  

