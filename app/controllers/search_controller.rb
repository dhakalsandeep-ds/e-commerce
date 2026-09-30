class SearchController < ApplicationController
  def show
    @query = params[:q].presence&.strip

    if @query.blank?
      @products = []
    else
      @products = Product
                   .includes(:category, :image_attachment)
                   .where("LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)", "%#{@query}%", "%#{@query}%")
                   .limit(100) 

      if params[:category_id].present?
        @products = @products.where(category_id: params[:category_id])
      end

      @products = @products.page(params[:page]).per(24)
    end
  end
end