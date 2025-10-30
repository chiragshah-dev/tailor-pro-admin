class Setting < ApplicationRecord
  enum :measurement_unit, { cms: 0, inch: 1 }
  enum :order_number_format, { random: 0, serial: 1, custom: 2 }

  ORDER_STATUSES = {
    accepted: 0, in_progress: 1, completed: 2, ready_for_trial: 3, delivered: 4, cancelled: 5
  }.freeze

  # Associations
  belongs_to :user

  # Validations
  validates :measurement_unit, :order_number_format, :default_order_list_days, presence: true
  validates :show_measurements_to_customer, :is_gst_enabled, :send_message_to_customer,
            :show_standard_dress_to_customer,
            inclusion: { in: [ true, false ], message: "must be true or false" }

  validates :gst_number, presence: true, format: {
    with: /\A\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d{1}Z[A-Z\d]{1}\z/,
    message: "must be in the format of 27ABCDE1234F1Z5"
  }, if: :is_gst_enabled?

  validates :gst_rate, presence: true, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  }, if: :is_gst_enabled?

  validates :include_gst_in_price, inclusion: {
    in: [ true, false ], message: "must be true or false"
  }, if: :is_gst_enabled?

  validate :order_statuses_must_be_valid, if: :send_message_to_customer?

  CURRENCIES = [
    { code: 'USD', name: 'US Dollar', symbol: '$' },
    { code: 'EUR', name: 'Euro', symbol: '€' },
    { code: 'GBP', name: 'British Pound', symbol: '£' },
    { code: 'INR', name: 'Indian Rupee', symbol: '₹' },
    { code: 'JPY', name: 'Japanese Yen', symbol: '¥' },
    { code: 'AUD', name: 'Australian Dollar', symbol: 'A$' },
    { code: 'CAD', name: 'Canadian Dollar', symbol: 'C$' },
    { code: 'CNY', name: 'Chinese Yuan', symbol: '¥' },
    { code: 'KRW', name: 'South Korean Won', symbol: '₩' },
    { code: 'BRL', name: 'Brazilian Real', symbol: 'R$' },
    { code: 'RUB', name: 'Russian Ruble', symbol: '₽' },
    { code: 'ZAR', name: 'South African Rand', symbol: 'R' },
    { code: 'SAR', name: 'Saudi Riyal', symbol: 'ر.س' },
    { code: 'AED', name: 'UAE Dirham', symbol: 'د.إ' },
    { code: 'CHF', name: 'Swiss Franc', symbol: 'CHF' },
    { code: 'SGD', name: 'Singapore Dollar', symbol: 'S$' }
  ].freeze

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "currency_type", "default_order_list_days", "gst_number", "gst_rate", "id", "include_gst_in_price", "is_gst_enabled", "measurement_unit", "order_number_format", "order_statuses_for_message", "send_message_to_customer", "show_measurements_to_customer", "show_standard_dress_to_customer", "updated_at", "user_id"]
  end

  private

  def order_statuses_must_be_valid
    return if order_statuses_for_message.blank?

    valid_keys   = ORDER_STATUSES.keys.map(&:to_s)
    valid_values = ORDER_STATUSES.values.map(&:to_i)

    invalid_entries = order_statuses_for_message.reject do |status|
      valid_keys.include?(status.to_s) || valid_values.include?(status.to_i)
    end

    if invalid_entries.any?
      errors.add(:order_statuses_for_message, "contains invalid statuses: #{invalid_entries.join(', ')}")
    end
  end
end
