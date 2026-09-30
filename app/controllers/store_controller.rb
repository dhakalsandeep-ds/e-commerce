class StoreController < ApplicationController
   def index
    @products = Product.where(published: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end 

  def smart_collection
  @collection = Collection.find_by!(handle: params[:handle])
  @products = @collection.products.page(params[:page])
  render :index
end

end
