class AdminUser < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end

  # Role management
  rolify

  # Optional: convenience helpers
  def super_admin?
    has_role?(:super_admin)
  end

  def manager?
    has_role?(:manager)
  end

  def staff?
    has_role?(:staff)
  end
end
