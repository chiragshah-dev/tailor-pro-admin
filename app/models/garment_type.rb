class GarmentType < ApplicationRecord
	enum :gender, { male: 0, female: 1, both: 2 }
	has_one_attached :image
	# has_many :measurement_fields, dependent: :destroy
	has_many :garment_type_measurements, dependent: :destroy
  	has_many :measurement_fields, through: :garment_type_measurements
	has_many :store_measurement_fields, dependent: :destroy
end
