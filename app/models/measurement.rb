class Measurement < ApplicationRecord
  enum :gender, { male: 0, female: 1 }

  # associations
  has_one_attached :image
  has_many :customer_measurements, dependent: :destroy
  has_many :customers, through: :customer_measurements
  has_many :dress_measurements, dependent: :destroy
  has_many :dresses, through: :dress_measurements

  # validations
  validates :name, :gender, presence: true

  # Scopes
  scope :for_gender, ->(gender) { where(gender: gender ) }
end
