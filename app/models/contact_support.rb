class ContactSupport < ApplicationRecord
  include Auditable

  has_many_attached :attachments
  belongs_to :user

  enum :status, { open: "open", closed: "closed" }

  validates :subject, :body, :email, presence: true
end
