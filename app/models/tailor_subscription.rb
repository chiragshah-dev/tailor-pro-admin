class TailorSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscription_package
end