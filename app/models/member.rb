class Member < ApplicationRecord
  # Associations
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  # Validations
  validates :name, presence: true
end
