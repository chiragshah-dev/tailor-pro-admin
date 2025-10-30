class DressMeasurement < ApplicationRecord
  # Associations
  belongs_to :dress
  belongs_to :measurement, optional: true
  has_one_attached :image
  has_many :customer_dress_measurement_values, dependent: :destroy

  # Validations
  validates :name, presence: true
end
