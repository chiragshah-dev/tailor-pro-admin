class CurrencyCountry < ApplicationRecord
  belongs_to :currency

  validates :country_code, presence: true, uniqueness: true
  validates :country_name, presence: true, uniqueness: true
end
