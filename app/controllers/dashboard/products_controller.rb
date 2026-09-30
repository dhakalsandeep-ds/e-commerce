class Dashboard::ProductsController < DashboardController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

   def index
    Rails.logger.info "<<<<<<<<<<<<<<<<<< Hello world >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    puts "HElo form index >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    
    products = Product.with_attached_image
                     .with_attached_thumbnails
                     .includes(:variants, :category)

    # Filter by category if selected
    if params[:category_id].present?
      products = products.where(category_id: params[:category_id])
    end

    # Search filter
    if params[:query].present?
      products = products.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    end

    # Get all categories for the dropdown (move this to the instance variable)
    @categories = Category.order(:name).all

    # Sorting
    allowed_sorts = %w[name price created_at]
    sort_field = allowed_sorts.include?(params[:sort]&.downcase) ? params[:sort] : "created_at"
    sort_order = params[:direction] == "asc" ? :asc : :desc
    products = products.order(sort_field => sort_order)

    # Pagination
    per_page = [5, 10, 25, 50, 100].include?(params[:per_page]&.to_i) ? params[:per_page].to_i : 25
    @products = products.page(params[:page]).per(per_page)
        @categories = Category.order(:name)
  end

  def show
  end

  def new
    @product = Product.new
    @option_types = OptionType.includes(:option_values).all
  end

  def create
      Rails.logger.debug "📸 MAIN IMAGE IN PARAMS: #{params.dig(:product, :image).inspect}"
  Rails.logger.debug "🖼️ THUMBNAILS IN PARAMS: #{params.dig(:product, :thumbnails).inspect}"
  Rails.logger.debug "📦 VARIANT IMAGES: #{params.dig(:product, :variants_attributes)&.values&.map { |v| v['image'] }}"

    @product = Product.new(product_params)
    @option_types = OptionType.includes(:option_values).all

    #   # Auto-create default variant if none provided (simple product)
    #   if @product.variants.none? && params.dig(:option_type_ids).blank?
      
    #   # Create a simple variant with placeholder values that pass validation
    #   @product.variants.build(sku: "SIMPLE-#{@product.name&.parameterize || 'product'}", price: 1.0, stock: 0)
    # end

    if @product.save
      redirect_to dashboard_product_path(@product), notice: "Product created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @option_types = OptionType.includes(:option_values).all
  end

  def update
    @option_types = OptionType.includes(:option_values).all

    if @product.update(product_params)
      redirect_to dashboard_product_path(@product), notice: "Product updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to dashboard_products_path, notice: "Product deleted."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
       :image,
      :name,
      :description,
      :category_id,
      # :status,
     
      thumbnails: [],
      collection_ids: [],
      variants_attributes: [
        :id,
        :sku,
        :price,
        :stock,
        :_destroy,
        :image,                 # variant image
        option_value_ids: []
      ]
    )
  end
end