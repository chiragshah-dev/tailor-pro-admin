class AdminModule < ApplicationRecord
  has_many :admin_module_actions, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :namespace, presence: true
end
