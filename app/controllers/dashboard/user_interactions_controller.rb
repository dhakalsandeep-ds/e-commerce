class Dashboard::UserInteractionsController < DashboardController
  before_action :authenticate_user!
  before_action :set_user_interaction, only: [ :show, :edit, :update, :destroy ]

  def index
  @search_query = params[:search].presence

  interactions = UserInteraction.includes(:user, :product)

  if @search_query
    # Search in user email OR product name
    interactions = interactions.where(
      User.arel_table[:email].matches("%#{@search_query}%")
        .or(Product.arel_table[:name].matches("%#{@search_query}%"))
    ).joins(:user, :product)
  end

  @user_interactions = interactions
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(20)
end

  def show
  end

  def new
  @user_interaction = UserInteraction.new
  @users = User.customer.order(:email)
  @products = Product.all
end

def edit
  @users = User.customer.order(:email)
  @products = Product.all 
end

  def create
    @user_interaction = UserInteraction.new(user_interaction_params)

    if @user_interaction.save
      redirect_to dashboard_user_interactions_path, notice: "User interaction created."
    else
      @users = User.customer.order(:email)
      @products = Product.published.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  # def edit
  #   @users = User.customer.order(:email)
  #   @products = Product.published.order(:name)
  # end

  def update
    if @user_interaction.update(user_interaction_params)
      redirect_to dashboard_user_interactions_path, notice: "User interaction updated."
    else
      @users = User.customer.order(:email)
      @products = Product.published.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_interaction.destroy!
    redirect_to dashboard_user_interactions_path, notice: "User interaction deleted."
  rescue => e
    redirect_to dashboard_user_interactions_path, alert: "Error: #{e.message}"
  end

  private

  def set_user_interaction
    @user_interaction = UserInteraction.find(params[:id])
  end

  def user_interaction_params
    params.require(:user_interaction).permit(:user_id, :product_id, :interaction_type, :score)
  end
end