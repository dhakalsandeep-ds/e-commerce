class Product < ApplicationRecord

  

 has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :product_option_types, dependent: :destroy
  has_many :option_types, through: :product_option_types
   has_many :user_interactions, dependent: :destroy
  has_many :variants, dependent: :destroy

  belongs_to :category, optional: true

  has_one_attached :image 
  has_many_attached :thumbnails
  has_rich_text :description

  validates :name, presence: true

  validate :image_type
  validate :thumbnails_type

  accepts_nested_attributes_for :option_types, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :variants, allow_destroy: true


 def min_variant_price
    variants.minimum(:price)
  end

  def image_type
    return unless image.attached?
    unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
      errors.add(:image, "must be a PNG, JPG, JPEG, or WEBP")
    end
  end

  def thumbnails_type
    thumbnails.each do |thumb|
      unless thumb.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
        errors.add(:thumbnails, "must be PNG, JPG, JPEG, or WEBP")
      end
    end
  end

   validate :max_three_option_types

  private

  def max_three_option_types
    if option_types.size > 3
      errors.add(:option_types, "cannot exceed 3 option types")
    end
  end


  scope :published, -> { where(published: true) }


end