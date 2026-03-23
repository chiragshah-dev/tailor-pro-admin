class Role < ApplicationRecord
  include Auditable

  has_many :admin_users, dependent: :restrict_with_error
  has_many :admin_permissions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
end
