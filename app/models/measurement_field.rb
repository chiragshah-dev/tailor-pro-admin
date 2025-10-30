class MeasurementField < ApplicationRecord
	has_one_attached :image
	belongs_to :garment_type, optional: true
end