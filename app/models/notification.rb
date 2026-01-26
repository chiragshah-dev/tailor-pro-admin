class Notification < ApplicationRecord
  include Auditable
  belongs_to :recipient, polymorphic: true
  belongs_to :sender, polymorphic: true, optional: true
  has_many :push_notifications, dependent: :destroy

  # Validations
  validates :title, :body, presence: true
end
