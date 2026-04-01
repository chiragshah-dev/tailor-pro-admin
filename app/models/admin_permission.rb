class AdminPermission < ApplicationRecord
  belongs_to :role
  belongs_to :admin_module_action
  validates :admin_module_action_id, uniqueness: { scope: :role_id }
end
