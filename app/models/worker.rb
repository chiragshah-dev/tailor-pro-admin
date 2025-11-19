class Worker < ApplicationRecord
  has_secure_password :mpin, validations: false
  # Associations
  belongs_to :job_role
  belongs_to :store
  has_many :order_items
  has_many :orders
  # Validations
  validates :name, presence: true
  validates :contact_number, presence: true, uniqueness: { scope: :store_id },
            numericality: { only_integer: true }, length: { is: 10 }

  # attr_accessor :otp_code

  def self.ransackable_attributes(auth_object = nil)
    ["active", "contact_number", "created_at", "id", "id_value", "job_role_id", "jti", "mpin_digest", "name", "otp_code", "store_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["job_role", "order_items", "orders", "store"]
  end
end
