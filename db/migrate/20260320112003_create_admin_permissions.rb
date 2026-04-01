class CreateAdminPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.references :admin_module_action, null: false, foreign_key: true

      t.timestamps
    end

    add_index :admin_permissions, [:role_id, :admin_module_action_id], unique: true
  end
end
