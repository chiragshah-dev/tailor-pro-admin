class CreateAdminModuleActions < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_module_actions do |t|
      t.references :admin_module, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :admin_module_actions, [:admin_module_id, :name], unique: true
  end
end
