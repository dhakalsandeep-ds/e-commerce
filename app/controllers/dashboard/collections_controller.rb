class Dashboard::CollectionsController < ApplicationController 

  helper Dashboard::CollectionsHelper

  def index
    @collections = Collection.all
  end

  def new
    @collection = Collection.new
    @collection.rules = [] 
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.handle = @collection.title.parameterize 

    if @collection.save
      redirect_to dashboard_collections_path, notice: "Collection created."
    else
      render :new
    end
  end

  def edit
    @collection = Collection.find(params[:id])
    @collection.rules ||= [] 
  end

  def update
    @collection = Collection.find(params[:id])
    @collection.handle = @collection.title.parameterize 

    if @collection.update(collection_params)
      redirect_to dashboard_collections_path, notice: "Collection updated."
    else
      render :edit
    end
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy
    redirect_to dashboard_collections_path, notice: "Collection deleted."
  end 

  def preview
  rules = params[:rules] || []

  scope = Product.all

  rules.each do |rule|
    field = rule["field"]
    predicate = rule["predicate"]
    value = rule["value"]

    next unless field && predicate && value.present?

    case field
    when "price"
      parsed_value = value.to_f
      next if parsed_value <= 0

      case predicate
      when "is"
        scope = scope.where("price = ?", parsed_value)
      when "less_than"
        scope = scope.where("price < ?", parsed_value)
      when "greater_than"
        scope = scope.where("price > ?", parsed_value)
      end
    end
  end

  count = scope.count

  render json: { count: count }
end

  private

  def collection_params
    params.require(:collection)
          .permit(:title, :handle, rules: [:field, :predicate, :value]) 
  end
end
