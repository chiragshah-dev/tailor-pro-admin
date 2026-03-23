class AddRoleIdToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :admin_users, :role, null: false, foreign_key: true
  end
end
