class Category < ApplicationRecord 
     has_many :products, dependent: :destroy

  # Add ActiveStorage attachment for image
  has_one_attached :image
end
