class Task < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validates :days, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "days", "id", "name", "updated_at", "user_id"]
  end
end
