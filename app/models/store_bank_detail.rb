class StoreBankDetail < ApplicationRecord
  include Auditable

  belongs_to :store
  has_one_attached :qr_code
end
