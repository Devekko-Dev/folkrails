class Product < ApplicationRecord
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  after_commit -> { broadcast_refresh_later_to "products" }
  validates :title, :subtitle, :description, :image, :price, presence: true
  validates :title, uniqueness: true  
  validate :acceptable_image
  def acceptable_image
    return unless image.attached?
      acceptable_types = [ "image/gif", "image/jpeg", "image/png", "image/webp" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a GIF, JPG, PNG or WEBP image")
    end
  end

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
end
