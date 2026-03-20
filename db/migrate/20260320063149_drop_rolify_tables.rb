class DropRolifyTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :admin_users_roles
    drop_table :roles
  end
end
