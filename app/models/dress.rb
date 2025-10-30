class Dress < ApplicationRecord
  enum :gender, { male: 0, female: 1 }

  # associations
  belongs_to :user, optional: true
  has_many :dress_stitch_features, dependent: :destroy
  has_many :stitch_features, through: :dress_stitch_features
  has_many :dress_measurements, dependent: :destroy
  has_many :measurements, through: :dress_measurements
  has_many :order_items, dependent: :destroy
  has_many :customer_dress_measurements, dependent: :destroy
  has_one_attached :dress_image
  # validations
  validates :name, :gender, presence: true
  validate :immutable_if_default

  # Scopes
  scope :accessible_by, ->(user) { where(user: [nil, user]) }
  scope :for_gender, ->(gender) { where(gender: gender ) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gender", "id", "is_default", "name", "price", "updated_at", "user_id"]
  end

  private

  def immutable_if_default
    if is_default? && (name_changed? || gender_changed? || price_changed?)
      errors.add(:base, 'Default dresses cannot be modified')
    end
  end
end
