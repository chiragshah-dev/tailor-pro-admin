class StoreBankDetail < ApplicationRecord
  belongs_to :store
  has_one_attached :qr_code
end
