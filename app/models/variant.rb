class Variant < ApplicationRecord
  belongs_to :product
  has_many :variant_option_values, dependent: :destroy
  has_many :option_values, through: :variant_option_values
  has_one_attached :image

    accepts_nested_attributes_for :variant_option_values, allow_destroy: true


   def option_value_ids=(ids)
    ids = ids.reject(&:blank?) if ids.is_a?(Array)
    self.variant_option_values.destroy_all
    ids.each do |id|
      self.variant_option_values.build(option_value_id: id)
    end
  end


  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
end