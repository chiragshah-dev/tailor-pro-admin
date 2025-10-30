class TailorSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscription_package

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "expiry_date", "id", "start_date", "subscription_package_id", "updated_at", "user_id"]
  end
end
