class StitchIt::GarmentTypeMeasurement < ApplicationRecord
  belongs_to :garment_type,
             class_name: "StitchIt::GarmentType"

  belongs_to :measurement_field,
             class_name: "StitchIt::MeasurementField"
end
