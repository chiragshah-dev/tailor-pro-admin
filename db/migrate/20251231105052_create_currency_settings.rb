class CreateCurrencySettings < ActiveRecord::Migration[8.0]
  def change
    create_table :currency_settings do |t|
      t.string  :country, null: false
      t.string  :currency_code, null: false
      t.decimal :amount_limit, precision: 12, scale: 2, null: false

      t.timestamps
    end

    add_index :currency_settings, :currency_code, unique: true
  end
end
