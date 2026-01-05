class Currency < ApplicationRecord
  has_one :currency_setting, dependent: :destroy
  has_many :currency_countries, dependent: :destroy

  after_create :create_currency_countries

  validates :name,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[A-Z]{3}\z/,
              message: "must be a valid ISO 4217 currency code (e.g. USD, INR, GBP)"
            }

  private

  def create_currency_countries
    CurrencyCountryMapper.call(self)
  end
end
