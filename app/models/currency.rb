class Currency < ApplicationRecord
  include Auditable

  has_one :currency_setting, dependent: :destroy
  has_many :currency_countries, dependent: :destroy

  after_create :create_currency_countries

  validates :name,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[A-Z]{3}\z/,
              message: "must be a valid ISO 4217 currency code (e.g. USD, INR, GBP)",
            }

  def symbol
    Money::Currency.find(name)&.symbol
  end

  def country
    @country ||= ISO3166::Country.all.find do |c|
      c.currency_code == name
    end
  end

  # Generate flag emoji from ISO
  def flag_emoji
    return nil unless country&.alpha2

    country.alpha2.upcase.each_char.map do |char|
      (0x1F1E6 + char.ord - 65).chr(Encoding::UTF_8)
    end.join
  end

  private

  def self.from_country_code(country_code)
    CurrencyCountry.find_by(country_code: country_code)&.currency
  end

  def create_currency_countries
    CurrencyCountryMapper.call(self)
  end
end
