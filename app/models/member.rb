class Member < ApplicationRecord
  # Associations
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  # Validations
  validates :name, presence: true
end
