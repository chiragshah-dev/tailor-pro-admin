class CurrencyCountry < ApplicationRecord
  belongs_to :currency

  validates :country_code, presence: true
  validates :country_name, presence: true
end
