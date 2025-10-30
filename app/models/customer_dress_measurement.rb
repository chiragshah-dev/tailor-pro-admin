class CustomerDressMeasurement < ApplicationRecord
  enum :measurement_unit, { cms: 0, inch: 1 }

  # Associations
  belongs_to :customer
  belongs_to :dress
  has_many :customer_dress_measurement_values, dependent: :destroy
  has_many :dress_measurements, through: :customer_dress_measurement_values
  has_many :order_items

  # Validations
  validates :name, presence: true
  validate :no_duplicate_dress_measurements

  # Nested attributes
  accepts_nested_attributes_for :customer_dress_measurement_values, allow_destroy: true

  private

  def no_duplicate_dress_measurements
    ids = customer_dress_measurement_values.map(&:dress_measurement_id)
    duplicates = ids.tally.select { |_, count| count > 1 }.keys
    if duplicates.any?
      errors.add(:base, "Duplicate dress_measurement_id(s): #{duplicates.join(', ')} found in values")
    end
  end
end
