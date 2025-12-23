class JobRole < ApplicationRecord
  # Associations
  has_many :workers, dependent: :destroy

  # Validations
  validates :name, presence: true
end
