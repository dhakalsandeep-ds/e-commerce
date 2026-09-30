class Collection < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :handle, presence: true, uniqueness: { case_sensitive: false }

  before_save :set_handle

  private

  def set_handle
    self.handle ||= name.parameterize if name.present?
  end
end