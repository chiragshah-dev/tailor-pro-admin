class StitchOption < ApplicationRecord
  # associations
  belongs_to :stitch_feature
  has_one_attached :image

  # validations
  validates :name, presence: true
  validate :immutable_if_default_stitch_feature

  private

  def image_blob_id_changed?
    image_attachment&.persisted? && image_attachment&.saved_change_to_blob_id?
  end

  def immutable_if_default_stitch_feature
    if stitch_feature&.is_default? && (name_changed? || image_blob_id_changed?)
      errors.add(:base, 'Stitch options for default features cannot be modified')
    end
  end
end
