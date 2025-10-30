class CustomerMeasurement < ApplicationRecord
  # associations
  belongs_to :customer
  belongs_to :measurement

  # validations
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validate :gender_consistency

  default_scope { order(:measurement_id) }

  scope :for_gender, ->(gender) {
    includes(:measurement).where(measurements: { gender: gender })
  }

  before_validation :set_value_if_blank

  private

  def gender_consistency
    if measurement.gender != customer.gender
      errors.add(:measurement, "must match customer's gender (#{customer.gender})")
    end
  end

  def set_value_if_blank
    self.value = 0 if value.blank?
  end
end
