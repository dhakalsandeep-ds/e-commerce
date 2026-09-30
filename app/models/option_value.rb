class OptionValue < ApplicationRecord
  belongs_to :option_type
  validates :name, presence: true 
    has_many :variant_option_values, dependent: :destroy
  has_many :variants, through: :variant_option_values

   before_destroy :ensure_not_used_by_variants

  private

  def ensure_not_used_by_variants
    if variants.exists?
      errors.add(:base, "Cannot delete: used by #{variants.count} variant(s)")
      throw :abort
    end
  end
end