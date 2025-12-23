class MeasurementField < ApplicationRecord
	has_one_attached :measurement_image
	belongs_to :garment_type, optional: true
	has_many :store_measurement_fields, dependent: :destroy
	has_many :order_measurements, dependent: :nullify
	has_many :garment_type_measurements, dependent: :destroy
  	has_many :garment_types, through: :garment_type_measurements
end