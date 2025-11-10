class StoreMeasurementField < ApplicationRecord
  belongs_to :store
  belongs_to :garment_type
  belongs_to :measurement_field, optional: true
  has_many :order_measurements, dependent: :nullify
  has_one_attached :measurement_image

  def edited?
    changes_data.present? && changes_data["original"] != changes_data["updated"]
  end

  before_validation :set_default_name, if: -> { name.blank? && label.present? }

  private

  def set_default_name
    # e.g. "Sleeve Length" -> "sleeve_length"
    self.name = label.to_s.parameterize.underscore
  end
end
