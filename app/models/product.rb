class Product < ApplicationRecord
  mount_uploaders :images, ProductImageUploader
  validates :title, :description, :images, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
end
