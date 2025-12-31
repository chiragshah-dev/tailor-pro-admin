# app/models/currency_setting.rb
class CurrencySetting < ApplicationRecord
  SUPPORTED_CURRENCIES = {
    "India" => "INR",
    "United States" => "USD",
    "Europe" => "EUR"
  }.freeze

  validates :country, :currency_code, :amount_limit, presence: true
  validates :currency_code, inclusion: { in: SUPPORTED_CURRENCIES.values }
  validates :amount_limit, numericality: { greater_than: 0 }
end
