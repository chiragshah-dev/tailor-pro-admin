# app/models/user_subscription.rb

class UserSubscription < ApplicationRecord
  include Auditable

  belongs_to :user
  belongs_to :subscription_package

  STATUSES = %w[active expired cancelled pending].freeze
  BILLING_CYCLES = %w[monthly yearly].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :billing_cycle, inclusion: { in: BILLING_CYCLES }
  validates :started_at, presence: true

  scope :active, -> { where(status: "active") }
  scope :expired, -> { where(status: "expired") }
  scope :cancelled, -> { where(status: "cancelled") }
  scope :pending, -> { where(status: "pending") }

  # current = active AND (never expires OR not yet expired)
  scope :current, -> {
          active.where("expires_at IS NULL OR expires_at > ?", Time.current)
        }

  # paid = any non-free subscription
  scope :paid, -> {
          joins(:subscription_package)
            .where.not(subscription_packages: { billing_type: "free" })
        }

  def active?
    status == "active" && (expires_at.nil? || expires_at > Time.current)
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def free?
    subscription_package.billing_type == "free"
  end

  def days_remaining
    return nil if expires_at.nil?
    [(expires_at.to_date - Date.current).to_i, 0].max
  end

  def cancel!
    update!(status: "cancelled", cancelled_at: Time.current, auto_renew: false)
  end

  def invoice_fee_percent
    subscription_package.invoice_fee_percent
  end

  def invoice_fee_for(amount)
    (amount * invoice_fee_percent / 100.0).round(2)
  end
end
