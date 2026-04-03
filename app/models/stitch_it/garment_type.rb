class StitchIt::GarmentType < ApplicationRecord
  has_one_attached :image, service: :amazon_stitch_it
  enum :category_type, { single: 0, combo: 1 }
  enum :gender, { male: 0, female: 1 }
  has_many :garment_type_measurements,
           class_name: "StitchIt::GarmentTypeMeasurement",
           dependent: :destroy

  has_many :measurement_fields,
           through: :garment_type_measurements,
           source: :measurement_field
end
