class Dashboard::CustomerGroupsController < DashboardController
  before_action :authenticate_user!  # ensure only logged-in users can access

  # GET /dashboard/customer_groups
  def index
  # Fetch all users with assigned groups
  @users = User.order(:id).page(params[:page])

  # Map cluster numbers to names
  cluster_names = {
    "cluster_0" => "High Value",
    "cluster_1" => "Frequent Buyer",
    "cluster_2" => "At Risk",
    "cluster_3" => "Low Value",
    "cluster_4" => "New Customer"
  }

  # Group users by cluster name
  @groups = @users.group_by { |u| cluster_names[u.customer_group] || "Unassigned" }
end


  # POST /dashboard/customer_groups/run_kmeans
  def run_kmeans
    k = params[:k].to_i
    # Example: features from orders (total spent, order count)
    users_scope = User.joins(orders: :order_items)
                      .select("users.id, SUM(order_items.price * order_items.quantity) AS total_spent, COUNT(DISTINCT orders.id) AS orders_count")
                      .group("users.id")

    # Assuming you have a KMeansSegmenter service
    result = KMeansSegmenter.new(k: k, normalize: true, scope: User.where(id: users_scope.map(&:id))).run!(persist: true)

    redirect_to dashboard_customer_groups_path, notice: "KMeans completed for K=#{k}. Inertia=#{result[:inertia].round(2)}"
  end

  # POST /dashboard/customer_groups/clear_groups
  def clear_groups
    User.update_all(customer_group: nil)
    redirect_to dashboard_customer_groups_path, notice: "Customer groups cleared"
  end
end
