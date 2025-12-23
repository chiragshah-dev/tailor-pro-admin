class Task < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validates :days, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
