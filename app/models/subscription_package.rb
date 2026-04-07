class SubscriptionPackage < ApplicationRecord
  include Auditable
  # has_many :tailor_subscriptions

  # # Safely calculate duration in days
  # def total_duration_in_days
  #   return duration_in_days if duration_in_days.present?
  #   return duration_month * 30 if duration_month.present?
  #   return duration_year * 365 if duration_year.present?
  #   0
  # end

  BILLING_TYPES = %w[free paid].freeze
  CURRENCIES    = %w[INR USD EUR GBP].freeze

  # -------------------------
  # Validations
  # -------------------------
  validates :name,                 presence: true
  validates :price_month,         numericality: { greater_than_or_equal_to: 0 }
  validates :price_year,          numericality: { greater_than_or_equal_to: 0 }
  validates :invoice_fee_percent,  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :billing_type,         inclusion: { in: BILLING_TYPES }
  validates :currency,             inclusion: { in: CURRENCIES }

  # -------------------------
  # Scopes
  # -------------------------
  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # -------------------------
  # Helpers
  # -------------------------
  def free?
    price_month.zero? && price_year.zero?
  end

  def invoice_fee_rate
    invoice_fee_percent / 100.0
  end

  def invoice_fee_for(amount)
    (amount * invoice_fee_rate).round(2)
  end

  def price_for(cycle)
    cycle.to_s == "yearly" ? price_year : price_month
  end

  def symbol
    Money::Currency.find(currency)&.symbol
  end
end
