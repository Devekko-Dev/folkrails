class Product < ApplicationRecord
  validates :title, :subtitle, :description, :image, :price, presence: true
  has_one_attached :image
  after_commit -> { broadcast_refresh_later_to "products" }
end
