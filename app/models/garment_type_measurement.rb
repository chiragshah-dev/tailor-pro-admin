class GarmentTypeMeasurement < ApplicationRecord
  include Auditable

  belongs_to :garment_type
  belongs_to :measurement_field

  validates :sequence,
              numericality: { only_integer: true },
              uniqueness: { scope: :garment_type_id },
              allow_nil: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "garment_type_id", "id", "measurement_field_id", "updated_at"]
  end
end
