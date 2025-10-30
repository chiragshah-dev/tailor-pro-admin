class SubscriptionPackage < ApplicationRecord
  has_many :tailor_subscriptions

  # Safely calculate duration in days
  def total_duration_in_days
    return duration_in_days if duration_in_days.present?
    return duration_month * 30 if duration_month.present?
    return duration_year * 365 if duration_year.present?
    0
  end
end