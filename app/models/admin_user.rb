class AdminUser < ApplicationRecord
  # rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :admin_permissions, through: :role

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  delegate :super_admin?, to: :role
  delegate :display_name, to: :role, prefix: true  # gives role_display_name

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["roles"]
  end
end
