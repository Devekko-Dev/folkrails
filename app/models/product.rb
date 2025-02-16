class Product < ApplicationRecord
  validates :title, :subtitle, :description, :image, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true  
  has_one_attached :image
  after_commit -> { broadcast_refresh_later_to "products" }
  validate :acceptable_image
  
  def acceptable_image
    return unless image.attached?
      acceptable_types = [ "image/gif", "image/jpeg", "image/png", "image/webp" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a GIF, JPG, PNG or WEBP image")
    end
  end

end
