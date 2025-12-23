class StitchFeature < ApplicationRecord
  enum :value_selection_type, { radio: 0, multiple: 1, textbox: 2 }
  enum :gender, { male: 0, female: 1 }

  # associations
  belongs_to :user, optional: true
  has_many :stitch_options, dependent: :destroy
  has_many :dress_stitch_features, dependent: :destroy
  has_many :dresses, through: :dress_stitch_features

  accepts_nested_attributes_for :stitch_options, allow_destroy: true

  # validations
  validates :name, :value_selection_type, :gender, presence: true
  validate :immutable_if_default

  # Scopes
  scope :accessible_by, ->(user) { where(user: [nil, user]) }
  scope :for_gender, ->(gender) { where(gender: gender ) }

  private

  def immutable_if_default
    if is_default? && (name_changed? || value_selection_type_changed? || gender_changed?)
      errors.add(:base, 'Default stitch features cannot be modified')
    end
  end
end
