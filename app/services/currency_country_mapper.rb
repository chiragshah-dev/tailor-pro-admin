require "set"

class CurrencyCountryMapper
  def self.call(currency)
    seen_codes = Set.new

    ISO3166::Country.all.each do |country|
      next unless country.currency_code == currency.name
      next if country.country_code.blank?

      code = "+#{country.country_code}"

      # prevent duplicate calling codes like +1 for USD
      next if seen_codes.include?(code)

      CurrencyCountry.find_or_create_by!(
        currency_id: currency.id,
        country_code: code,
        country_name: country.common_name
      )

      seen_codes.add(code)
    end
  end
end
