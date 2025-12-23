class Notification < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, :body, presence: true
end
