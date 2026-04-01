class StitchIt::MeasurementField < ApplicationRecord
  has_many :garment_type_measurements,
           class_name: "StitchIt::GarmentTypeMeasurement",
           dependent: :destroy

  has_many :garment_types,
           through: :garment_type_measurements,
           source: :garment_type
end
