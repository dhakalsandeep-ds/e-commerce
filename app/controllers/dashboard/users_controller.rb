# app/controllers/dashboard/users_controller.rb
class Dashboard::UsersController < DashboardController # Or your specific base dashboard controller
  before_action :authenticate_user! # Assuming you use Devise or similar
  # Add authorization check here if needed (e.g., Pundit, CanCanCan, or a simple check)
  # before_action :ensure_user_is_admin_or_seller

  before_action :set_user, only: [:show, :edit, :update, :destroy]

 def index
  Rails.logger.info "<<<<<<<<<< Customers Index >>>>>>>>>>>"

  # Start with all customers
  @users = User.all

  # Optional search by first_name, last_name, or email
  if params[:query].present?
    query = "%#{params[:query].downcase}%"
    @users = @users.where(
      "LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(email) LIKE :q",
      q: query
    )
  end

  # Filter by customer group
  @segment_names = ["All", "VIP", "Loyal", "New", "At-Risk", "Low Value"]
  if params[:customer_group].present? && params[:customer_group] != "All"
    @users = @users.where(customer_group: params[:customer_group])
  end

  # Sorting
  allowed_sorts = %w[created_at first_name last_name email orders_count]
  sort_field = allowed_sorts.include?(params[:sort]&.downcase) ? params[:sort] : "created_at"
  sort_order = params[:direction] == "asc" ? :asc : :desc

  if sort_field == "orders_count"
    # Sort by number of orders
    @users = @users.left_joins(:orders)
                   .group(:id)
                   .order(Arel.sql("COUNT(orders.id) #{sort_order.upcase}"))
  else
    @users = @users.order(sort_field => sort_order)
  end

  # Kaminari pagination
  per_page = [5, 10, 25, 50, 100].include?(params[:per_page]&.to_i) ? params[:per_page].to_i : 10
  @users = @users.page(params[:page]).per(per_page)
end


  def show
    # @user is set by the before_action :set_user
    # You might want to eager load associated data like orders
    # @user = User.includes(:orders).find(params[:id]) # If not already done in set_user
  end

  # /user/:id/edit
  def edit
    # @user is set by the before_action :set_user
    # Pre-populate the form with the user's current data
  end

  def update
    # @user is set by the before_action :set_user
    if @user.update(user_params)
      redirect_to dashboard_user_path(@user), notice: 'Customer updated successfully.'
    else
      # If update fails, re-render the edit form with errors
      render :edit, status: :unprocessable_entity
    end
  end



def new
  @user = User.new
end

def create
  @user = User.new(user_params)
  
  # Set a temporary password that meets your validation rules
  @user.password = "TempPass123!"  # uppercase, lowercase, number, special, 12 chars

  if @user.save
    redirect_to dashboard_user_path(@user), notice: "Customer created successfully."
  else
    render :new, status: :unprocessable_entity
  end
end


  def destroy
  # @user.addresses.delete_all # deletes related addresses in DB
  @user.destroy!
  redirect_to dashboard_users_path, notice: 'Customer deleted successfully.'
rescue => e
  redirect_to dashboard_users_path, alert: "Error deleting customer: #{e.message}"
end

 def run_kmeans
   
    result = KMeansSegmenter.new.run!(persist: true)
    # notice = result[:error] ? "Error: #{result[:error]}" : "KMeans done (k=#{5}, inertia=#{result[:inertia].round(2)})"
    notice = result[:error] ? "Error #{result[:error]}" : "trained"
    redirect_to dashboard_users_path, notice: notice
  end

  def clear_customer_groups
    User.update_all(customer_group: nil)
    redirect_to dashboard_users_path, notice: "Customer groups cleared."
  end


#   def destroy
#   @user.destroy!
#   redirect_to dashboard_users_path, notice: 'Customer deleted successfully.'
# rescue => e
#   redirect_to dashboard_users_path, alert: "Error deleting customer: #{e.message}"
# end


  # def destroy
  #   # @user is set by the before_action :set_user
  #   # --- Important: Consider implications of deletion ---
  #   # Option 1: Soft Delete (Recommended)
  #   # Mark user as inactive/deleted. Requires a boolean column like `deleted` or `active`.
  #   # @user.update(active: false) # Or @user.update(deleted: true)
  #   # redirect_to dashboard_users_path, notice: 'Customer deactivated.'

  #   # Option 2: Hard Delete (Use with extreme caution!)
  #   # This will permanently remove the user and potentially related data.
  #   # Ensure you understand the consequences (data loss, orphaned records).
  #   # @user.destroy!
  #   # redirect_to dashboard_users_path, notice: 'Customer deleted.'
  #   # --- End Deletion Options ---
  # rescue => e
  #   # Handle potential errors during destroy
  #   # redirect_to dashboard_users_path, alert: "Error deleting customer: #{e.message}"

  #    # Instead of @user.destroy!, mark the user as deleted
  #   # @user is set by the before_action :set_user
  #   if @user.mark_as_deleted!
  #     # Optional: Clear the session cart ID if associated with this user's cart
  #     # session.delete(:cart_id) if session[:cart_id] == @user.cart&.id

  #     redirect_to dashboard_users_path, notice: 'Customer marked as deleted.'
  #   else
  #     # Handle potential errors during the update (though unlikely with update!)
  #     redirect_to dashboard_users_path, alert: 'Error deleting customer.'
  #   end
  # rescue => e
  #   # Handle unexpected errors
  #   redirect_to dashboard_users_path, alert: "Error deleting customer: #{e.message}"


  # end

  private

  def set_user
    @user = User.find(params[:id])
    # Optional: Add authorization check here if needed
    # authorize @user, :manage? # Using Pundit example
  end

  # Define permitted parameters for updating a user
  # Be VERY CAREFUL what you permit here, especially roles/admin status.
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :phone_number,
      :address, :city, :state, :postal_code, :country,
      :date_of_birth # Add other permitted user attributes as needed
      # DO NOT permit :admin, :role, :password, :reset_password_token etc. unless absolutely necessary and secured.
    )
  end

  # def ensure_user_is_admin_or_seller
  #   # Implement your authorization logic here
  #   # redirect_to root_path, alert: 'Access denied' unless current_user.admin? || current_user.seller?
  # end
end