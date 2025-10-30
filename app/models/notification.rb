class Notification < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, :body, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "read", "title", "updated_at", "user_id"]
  end
end
