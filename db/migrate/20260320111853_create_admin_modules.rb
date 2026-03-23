class CreateAdminModules < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_modules do |t|
      t.string :name, null: false
      t.string :namespace, null: false, default: "admin"

      t.timestamps
    end

    add_index :admin_modules, :name, unique: true
  end
end
