class AddCommisionRateToCurrencySettings < ActiveRecord::Migration[8.0]
  def change
    add_column :currency_settings, :commission_rate, :decimal, precision: 10, scale: 4, default: 0.0, null: false
    add_column :currency_settings, :message, :text
  end
end
