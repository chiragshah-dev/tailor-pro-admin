class TailorEnquiry < ApplicationRecord
  validates :name, :email, presence: true
end
