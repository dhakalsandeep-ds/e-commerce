# app/models/user_interaction.rb
class UserInteraction < ApplicationRecord
  belongs_to :user
  belongs_to :product

  scope :for_user, ->(user) { where(user: user) }
  scope :for_product, ->(product) { where(product: product) }
  scope :purchases, -> { where(interaction_type: 'purchase') }
  scope :views, -> { where(interaction_type: 'view') }
  scope :cart_additions, -> { where(interaction_type: 'cart') }
end