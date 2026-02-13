class GarmentType < ApplicationRecord
  include Auditable

  enum :gender, { male: 0, female: 1, both: 2 }
  enum :garment_type, { single: 0, combo: 1 }
  has_one_attached :image
  # has_many :measurement_fields, dependent: :destroy
  has_many :garment_type_measurements, dependent: :destroy
  has_many :measurement_fields, through: :garment_type_measurements
  has_many :store_measurement_fields, dependent: :destroy
  has_many :order_items, dependent: :nullify
  # has_many :measurement_fields, dependent: :destroy
  # combos this garment owns
  has_many :combo_garments,
           foreign_key: :combo_id,
           dependent: :delete_all
  has_many :included_in_combos,
           class_name: "ComboGarment",
           foreign_key: :garment_type_id,
           dependent: :delete_all

  has_many :combo_items,
           through: :combo_garments,
           source: :garment_type
  validates :garment_name, presence: true

  scope :singles, -> { where(garment_type: :single) }
  scope :combos, -> { where(garment_type: :combo) }

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "garment_name", "gender", "id", "id_value", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["image_attachment", "image_blob", "measurement_fields", "store_measurement_fields"]
  end
end
