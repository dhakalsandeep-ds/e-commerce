class Dashboard::CategoriesController < DashboardController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order(:name).page(params[:page]).per(20)
 
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to dashboard_categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  

  def edit

  end

  def show 

  end

  def update
    if @category.update(category_params)
      redirect_to dashboard_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.products.any?
      redirect_to dashboard_categories_path, alert: 'Cannot delete category because it has associated products.'
    else
      @category.destroy
      redirect_to dashboard_categories_path, notice: 'Category was successfully deleted.'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

   def category_params
    params.require(:category).permit(:name, :description, :featured, :image)
  end
end
