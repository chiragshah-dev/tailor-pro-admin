class User < ApplicationRecord
  # include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable,
  #        :jwt_authenticatable, jwt_revocation_strategy: self

  # Validations
  validates :name, presence: true
  validates :contact_number, presence: true, uniqueness: true,
            numericality: { only_integer: true }, length: { is: 10 }
  has_secure_password :mpin, validations: false
  # validates :mpin, presence: true, format: { with: /\A\d{4}\z/ }, if: :login_with_mpin?
  validate :validate_mpin_format, if: -> { mpin.present? }

  # validates :password, presence: true,
  #           numericality: { only_integer: true }, length: { is: 4 },
  #           if: :should_validate_password?
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP, 
    message: "must be a valid email address (e.g., example@example.com)" 
  }, allow_blank: true

  # Associations
  has_many :stores, dependent: :destroy
  belongs_to :active_store, class_name: 'Store', optional: true
  has_many :tasks, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_many :stitch_features, dependent: :destroy
  has_many :dresses, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :job_roles, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :tailor_subscriptions, dependent: :destroy
  has_one :active_subscription, -> { where(active: true) }, class_name: "TailorSubscription"

  # Callbacks
  after_create :setup_default_records
  after_create :generate_and_send_otp
  attr_writer :login_with_mpin
  after_create :assign_free_subscription

  def self.ransackable_associations(auth_object = nil)
    ["active_store", "active_subscription", "dresses", "folders", "job_roles", "notifications", "setting", "stitch_features", "stores", "tailor_subscriptions", "tasks"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active_store_id", "contact_number", "country_code", "created_at", "device_id", "email", "encrypted_password", "id", "id_value", "jti", "mpin_digest", "name", "otp_code", "otp_sent_at", "otp_verified_at", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end

   def password_required?
    return false
    super
  end

  def current_store
    active_store || stores.first
  end

  # Set active store
  def set_active_store(store)
    return false unless store && stores.include?(store)
    update(active_store_id: store.id)
  end

  # Remove or disable email validations if inherited from Devise
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def email_changed?
    false
  end

  def email_was
    nil
  end

  # OTP methods
  def generate_and_send_otp
    otp_code = SecureRandom.random_number(1000..9999).to_s
    # otp_code = '1234'  # For testing purposes, use a fixed OTP
    otp_sent_at = Time.current
    update(otp_code: otp_code, otp_sent_at: otp_sent_at)

    # Placeholder for SMS sending (e.g., using Twilio)
    # SmsService.new(contact_number, "Your OTP is #{otp_code}").send
  end

  def verify_otp(code)
    return false if otp_code.nil?
    return false if otp_sent_at < 10.minutes.ago
    otp_code == code
  end

  private

  def setup_default_records
    UserSetupService.new(self).process
  end

  def should_validate_password?
    new_record? || password.present?
  end

  def validate_mpin_format
    unless mpin =~ /\A\d{4}\z/
      errors.add(:mpin, "must be exactly 4 digits")
    end
  end

   def assign_free_subscription
    free_package = SubscriptionPackage.find_by(name: "Free")
    return unless free_package

    # tailor_subscriptions.create!(
    #   subscription_package: free_package,
    #   start_date: Date.today,
    #   expiry_date: Date.today + free_package.duration_in_days.days,
    #   active: true,
    # )
    tailor_subscriptions.create!(
      subscription_package: free_package,
      start_date: Date.today,
      expiry_date: Date.today + free_package.duration_month.months,
      active: true,
    )
  end
end
