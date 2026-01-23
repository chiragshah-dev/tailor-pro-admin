class Member < ApplicationRecord
  include Auditable

  # Associations
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :order_measurements, dependent: :destroy
  # Validations
  validates :name, presence: true
end
