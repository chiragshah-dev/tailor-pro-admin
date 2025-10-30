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
end
