class ProductRecommendation < ApplicationRecord
  belongs_to :product
  belongs_to :recommended_product, class_name: "Product"
end
