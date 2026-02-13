class ComboGarment < ApplicationRecord
  belongs_to :combo, class_name: "GarmentType"
  belongs_to :garment_type

  validate :single_only

  def single_only
    if garment_type.combo?
      errors.add(:garment_type, "Combo cannot be added inside another combo")
    end
  end
end
