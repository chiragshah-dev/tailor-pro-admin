class GarmentTypeMeasurement < ApplicationRecord
  belongs_to :garment_type
  belongs_to :measurement_field
end
