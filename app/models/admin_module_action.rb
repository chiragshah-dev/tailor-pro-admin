class AdminModuleAction < ApplicationRecord
  belongs_to :admin_module
  has_many :admin_permissions, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :admin_module_id }
end
