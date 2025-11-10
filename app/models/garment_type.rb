class GarmentType < ApplicationRecord
	enum :gender, { male: 0, female: 1, both: 2 }
	has_one_attached :image
	has_many :measurement_fields, dependent: :destroy
	has_many :store_measurement_fields, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "garment_name", "gender", "id", "id_value", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["image_attachment", "image_blob", "measurement_fields", "store_measurement_fields"]
  end
end
