class DropRolifyTables < ActiveRecord::Migration[8.0]
  def up
    drop_table :admin_users_roles
    drop_table :roles
  end

  def down
    create_table :roles do |t|
      t.string :name
      t.string :resource_type
      t.bigint :resource_id
      t.timestamps
    end

    create_table :admin_users_roles, id: false do |t|
      t.bigint :admin_user_id
      t.bigint :role_id
    end

    add_index :roles, [:name, :resource_type, :resource_id]
    add_index :admin_users_roles, [:admin_user_id, :role_id]
  end
end
