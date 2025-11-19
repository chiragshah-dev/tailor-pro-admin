class JobRole < ApplicationRecord
  # Associations
  has_many :workers, dependent: :destroy

  # Validations
  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "workers"]
  end
end
