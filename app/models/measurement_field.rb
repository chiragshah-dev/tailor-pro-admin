class MeasurementField < ApplicationRecord
	has_one_attached :measurement_image
	belongs_to :garment_type, optional: true
	has_many :store_measurement_fields, dependent: :destroy
	has_many :order_measurements, dependent: :nullify

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "garment_type_id", "id", "id_value", "image_url", "label", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["garment_type", "measurement_image_attachment", "measurement_image_blob", "order_measurements", "store_measurement_fields"]
  end
end
