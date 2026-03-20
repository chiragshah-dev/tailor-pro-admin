class Role < ApplicationRecord
  include Auditable

  has_many :admin_users, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
end
