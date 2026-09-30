# app/controllers/storefront/categories_controller.rb
class Storefront::CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])  # ✅ Load the category

    # Reuse your existing product filtering/sorting logic
    products = Product.includes(:category).where(category_id: @category.id)

    if params[:min_price].present? || params[:max_price].present?
      products = products.joins(:variants)
      products = products.where("variants.price >= ?", params[:min_price].to_f) if params[:min_price].present?
      products = products.where("variants.price <= ?", params[:max_price].to_f) if params[:max_price].present?
      products = products.distinct
    end

    @products = products.joins(:variants)
                      .select("products.*, MIN(variants.price) AS min_variant_price")
                      .group("products.id")

    case params[:sort]&.strip
    when 'price_asc'
      @products = @products.order("min_variant_price ASC")
    when 'price_desc'
      @products = @products.order("min_variant_price DESC")
    when 'name_asc'
      @products = @products.order("products.name ASC")
    when 'name_desc'
      @products = @products.order("products.name DESC")
    else
      @products = @products.order("products.created_at DESC")
    end

    @products = @products.page(params[:page]).per(8)
  end
end