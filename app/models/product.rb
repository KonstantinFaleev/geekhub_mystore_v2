class Product < ApplicationRecord
  mount_uploaders :images, ProductImageUploader
end
