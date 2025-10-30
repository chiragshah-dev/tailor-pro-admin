class Folder < ApplicationRecord
  enum :gender, { male: 0, female: 1, both: 2 }

  # Associations
  belongs_to :user
  belongs_to :store
  has_many :media, class_name: "Media", dependent: :destroy

  # Validations
  validates :name, :gender, presence: true

  # Scopes
  scope :for_gender, ->(gender) { where(gender: [gender, 'unisex'] ) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gender", "id", "name", "store_id", "updated_at", "user_id"]
  end
end
