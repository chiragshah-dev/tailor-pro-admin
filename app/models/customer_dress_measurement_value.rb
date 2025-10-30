class CustomerDressMeasurementValue < ApplicationRecord
  # Associations
  belongs_to :customer_dress_measurement
  belongs_to :dress_measurement

  # Validations
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
