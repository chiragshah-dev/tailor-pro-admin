class PushNotification < ApplicationRecord
  belongs_to :notification
  belongs_to :receiver, polymorphic: true
end
