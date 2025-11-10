class Store < ApplicationRecord
  enum :store_type, { outlet: 0, workshop: 1, both: 2 }, prefix: true
  enum :stitches_for, { male: 0, female: 1, both: 2 }

  # validations
  # validates :name, :store_type, :stitches_for, :contact_number, :location_name,
  # :address, :city, :state, :country, :postal_code, presence: true
  validates :name, :contact_number, presence: true, on: :setup_profile
  validates :contact_number, numericality: { only_integer: true }, length: { is: 10 }
  validates :whatsapp_number, numericality: { only_integer: true }, length: { is: 10 }, allow_blank: true
  # validates :postal_code, numericality: { only_integer: true }, length: { is: 6 }
  validates :email, format: {
                      with: URI::MailTo::EMAIL_REGEXP,
                      message: "must be a valid email address (e.g., example@example.com)",
                    }, allow_blank: true

  validates :is_main_store, inclusion: { in: [true, false], message: "must be true or false" }

  validate :website_url_format, if: :website_url_present?

  # associations
  has_one_attached :logo
  has_many_attached :photos
  # has_many_attached :store_photos
  # has_many_attached :store_videos
  has_many :store_galleries, dependent: :destroy
  # Through associations
  has_many :men_galleries, -> { joins(:gallery_category).where(gallery_categories: { category_type: :men }) }, class_name: "StoreGallery"
  has_many :women_galleries, -> { joins(:gallery_category).where(gallery_categories: { category_type: :women }) }, class_name: "StoreGallery"
  has_many :custom_galleries, -> { joins(:gallery_category).where(gallery_categories: { category_type: :custom }) }, class_name: "StoreGallery"

  belongs_to :user
  has_many :customers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_one :backup_setting, dependent: :destroy
  has_many :folders, dependent: :destroy
  after_create :create_default_backup_setting

  has_many :store_service_expertises, dependent: :destroy
  has_many :expertises, -> { distinct }, through: :store_service_expertises
  has_many :services, -> { distinct }, through: :store_service_expertises
  has_one :store_bank_detail, dependent: :destroy
  has_many :store_measurement_fields, dependent: :destroy
  before_create :set_main_store

  accepts_nested_attributes_for :store_bank_detail

  def self.ransackable_attributes(auth_object = nil)
    ["address", "city", "code", "completed_steps", "contact_number", "country", "created_at", "email", "facebook_id", "gst_included_on_bill", "gst_name", "gst_number", "gst_percentage", "id", "instagram_id", "is_main_store", "last_visited_screen", "location_name", "map_location", "name", "postal_code", "state", "stitches_for", "store_type", "updated_at", "user_id", "website_url", "whatsapp_number"]
  end

  def full_address
    [address, location_name, city, state, country, postal_code].compact.reject(&:blank?).join(", ")
  end

  private

  def set_main_store
    # Make this store main if no other store exists in DB for this user
    self.is_main_store = !user.stores.exists?
  end

  def website_url_format
    uri = URI.parse(website_url)
    # Check for HTTP or HTTPS scheme
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:website_url, "must be a valid HTTP or HTTPS URL (e.g., https://example.com)")
      return # Exit if scheme fails
    end

    # Check if host exists and is a valid domain
    unless uri.host.present? && uri.host.match?(/\A[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])*)*\.[a-z]{2,}\z/i)
      errors.add(:website_url, "must include a valid domain (e.g., example.com)")
    end
  rescue URI::InvalidURIError
    errors.add(:website_url, "is not a valid URL")
  end

  def website_url_present?
    website_url.present?
  end

  def create_default_backup_setting
    create_backup_setting!(
      active: true,
      frequency: "monthly",   # default frequency
      delivery_type: "email", # default delivery type
    )
  end
end
