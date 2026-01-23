class Setting < ApplicationRecord
  include Auditable

  enum :measurement_unit, { cms: 0, inch: 1 }
  enum :order_number_format, { random: 0, serial: 1, custom: 2 }

  ORDER_STATUSES = {
    pending: 0, in_progress: 1, ready_for_trial: 2, completed: 4, delivered: 5, cancelled: 6,
  }.freeze

  # Associations
  belongs_to :user

  # Validations
  validates :measurement_unit, :order_number_format, :default_order_list_days, presence: true
  validates :show_measurements_to_customer, :is_gst_enabled, :send_message_to_customer,
            :show_standard_dress_to_customer,
            inclusion: { in: [true, false], message: "must be true or false" }

  # validates :gst_number, presence: true, format: {
  #                          with: /\A\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d{1}Z[A-Z\d]{1}\z/,
  #                          message: "must be in the format of 27ABCDE1234F1Z5",
  #                        }, if: :is_gst_enabled?

  # validates :gst_rate, presence: true, numericality: {
  #                        greater_than_or_equal_to: 0, less_than_or_equal_to: 100,
  #                      }, if: :is_gst_enabled?

  validates :include_gst_in_price, inclusion: {
                                     in: [true, false], message: "must be true or false",
                                   }, if: :is_gst_enabled?

  validate :order_statuses_must_be_valid, if: :send_message_to_customer?

  # CURRENCIES = ISO3166::Country.all.map do |country|
  #   next unless country.currency

  #   {
  #     dialing_code: "+#{country.country_code}", # Using countries gem
  #     flag: country.emoji_flag,
  #     currency_code: country.currency.iso_code,
  #     currency_symbol: country.currency.symbol,
  #   }
  # end.compact.freeze

  private

  def order_statuses_must_be_valid
    return if order_statuses_for_message.blank?

    valid_keys = ORDER_STATUSES.keys.map(&:to_s)
    valid_values = ORDER_STATUSES.values.map(&:to_i)

    invalid_entries = order_statuses_for_message.reject do |status|
      valid_keys.include?(status.to_s) || valid_values.include?(status.to_i)
    end

    if invalid_entries.any?
      errors.add(:order_statuses_for_message, "contains invalid statuses: #{invalid_entries.join(", ")}")
    end
  end
end
