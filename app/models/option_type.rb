class OptionType < ApplicationRecord
  has_many :option_values, dependent: :destroy
  has_many :product_option_types, dependent: :destroy
  has_many :products, through: :product_option_types

  # 🔸 Prevent deletion if used by any product
  before_destroy :ensure_not_used_by_products

 


  accepts_nested_attributes_for :option_values, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: { case_sensitive: false }



   private

  def ensure_not_used_by_products
    if products.exists?
      errors.add(:base, "Cannot delete: used by #{products.count} product(s)")
      throw :abort
    end
  end
end