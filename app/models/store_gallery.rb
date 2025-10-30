class StoreGallery < ApplicationRecord
  belongs_to :store
  belongs_to :gallery_category
  has_many_attached :files # can be photo or video

  # enum file_type: { image: 0, video: 1 }
  enum :file_type, { image: 0, video: 1 }

  # validates :file_type, presence: true
end
