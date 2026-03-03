class SystemNotification < ApplicationRecord
  include Auditable

  validates :title, :message, presence: true
end
