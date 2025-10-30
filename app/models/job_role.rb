class JobRole < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :workers, dependent: :destroy

  # Validations
  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at", "user_id"]
  end
end
