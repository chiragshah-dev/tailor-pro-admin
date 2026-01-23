# app/models/currency_setting.rb
class CurrencySetting < ApplicationRecord
  # Supported currencies are intentionally restricted for now.
  # Extend SUPPORTED_CURRENCIES when new countries are approved.
  # SUPPORTED_CURRENCIES = {
  #   "India" => "INR",
  #   "United States" => "USD",
  #   "Europe" => "EUR"
  # }.freeze

  # associations
  include Auditable

  belongs_to :currency

  validates :amount_limit, presence: true
  validates :amount_limit, numericality: { greater_than: 0 }
  validates :currency_id, presence: true, uniqueness: true
end
