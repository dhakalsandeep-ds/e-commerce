class ProductsController < ApplicationController
  def index
    @products = Product.all

   
    if params[:brand].present?
      @products = @products.where(brand: params[:brand])
    end

    if params[:min_price].present?
      @products = @products.where("price >= ?", params[:min_price].to_f)
    end

    if params[:max_price].present?
      @products = @products.where("price <= ?", params[:max_price].to_f)
    end


    sort_param = params[:sort]
    case sort_param
    when 'price_asc'
      @products = @products.order(:price)
    when 'price_desc'
      @products = @products.order(price: :desc)
    when 'name_asc'
      @products = @products.order(:name)
    when 'name_desc'
       @products = @products.order(name: :desc)
    else
      @products = @products.order(created_at: :desc) 
    end
   
    @pagy, @products = pagy(@products, items: 12) 
  end

  def show
    @product = Product.find(params[:id])
  end

 

end