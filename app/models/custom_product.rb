class CustomProduct < ApplicationRecord
  include Auditable

  belongs_to :order

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
