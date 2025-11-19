class RemoveUserIdFromJobRoles < ActiveRecord::Migration[8.0]
  def change
    remove_column :job_roles, :user_id, :bigint
  end
end
