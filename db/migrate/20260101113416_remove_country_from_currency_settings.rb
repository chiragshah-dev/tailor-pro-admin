class RemoveCountryFromCurrencySettings < ActiveRecord::Migration[8.0]
  def change
    remove_column :currency_settings, :country, :string
    remove_column :currency_settings, :currency_code, :string
  end
end
