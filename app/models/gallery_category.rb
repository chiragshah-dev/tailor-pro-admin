class GalleryCategory < ApplicationRecord
  has_many :store_galleries, dependent: :destroy

  enum :category_type, { men: 0, women: 1, custom: 2 }
end
