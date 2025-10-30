class Customer < ApplicationRecord
  enum :customer_reached_via, { social_media: 0, privilege_card: 1, online_search: 2,
                                news: 3, just_dial: 4, google_search: 5, friend_referral: 6,
                                other: 7 }
  enum :gender, { male: 0, female: 1 }

  # associations
  belongs_to :store
  has_one_attached :face_image
  has_many_attached :body_images
  has_many :customer_measurements, dependent: :destroy
  has_many :measurements, through: :customer_measurements
  has_many :orders, dependent: :destroy
  has_many :customer_dress_measurements, dependent: :destroy
  has_many :members, dependent: :destroy

  # validations
  # validates :name, :contact_number, :gender, presence: true
  validates :contact_number, numericality: { only_integer: true }, length: { is: 10 }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP, 
    message: "must be a valid email address (e.g., example@example.com)" 
  }, allow_blank: true

  validate :dob_validation, :storewise_unique_customers

  private

  def dob_validation
    if dob.present? && dob > Date.today
      errors.add(:dob, "can't be in future")
    end
  end

  def storewise_unique_customers
    if store.customers.where(contact_number: contact_number).where.not(id: id).exists?
      errors.add(:contact_number, "already exists for this store")
    end
  end
end
