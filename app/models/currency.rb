class Currency < ApplicationRecord
  has_one :currency_setting, dependent: :destroy
  has_many :currency_countries, dependent: :destroy

  after_create :create_currency_countries

  private

  def create_currency_countries
    CurrencyCountryMapper.call(self)
  end
end
