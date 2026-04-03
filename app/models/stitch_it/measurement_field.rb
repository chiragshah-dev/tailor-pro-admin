class StitchIt::MeasurementField < ApplicationRecord
  has_one_attached :image, service: :amazon_stitch_it
  has_many :garment_type_measurements,
           class_name: "StitchIt::GarmentTypeMeasurement",
           dependent: :destroy

  has_many :garment_types,
           through: :garment_type_measurements,
           source: :garment_type

  has_many :member_measurements,
           class_name: "StitchIt::MemberMeasurement",
           dependent: :destroy

  has_one :current_member_measurement, class_name: "StitchIt::MemberMeasurement"
end
