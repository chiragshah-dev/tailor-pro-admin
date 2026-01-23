class Notification < ApplicationRecord
  include Auditable

  # Associations
  belongs_to :user

  # Validations
  validates :title, :body, presence: true
end
