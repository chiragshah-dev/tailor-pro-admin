class OrderItem < ApplicationRecord
  enum :work_type, { stitching: 0, alteration: 1, material: 2, readymade: 3 }
  enum :status, {
    accepted: 0, in_progress: 1, pending_assign: 2, pending: 3, completed: 4, ready_for_trial: 5, delivered: 6, cancelled: 7
  }
  enum :stichfor, { male: 0, female: 1 }

  # Associations
  belongs_to :order
  belongs_to :dress, optional: true
  belongs_to :garment_type, optional: true
  has_many :order_item_stitch_features, dependent: :destroy
  has_many :stitch_features, through: :order_item_stitch_features
  has_many :order_measurements, dependent: :destroy
  accepts_nested_attributes_for :order_measurements, allow_destroy: true
  belongs_to :customer_dress_measurement, optional: true
  belongs_to :member, optional: true
  belongs_to :worker, optional: true

  # Validations
  # validates :name, :work_type, :price, :delivery_date, presence: true
  # validates :work_type, :price, :delivery_date, presence: true
  validate :video_link_format, if: :video_link_present?
  validate :date_validation
  validates :order_item_number, uniqueness: true
  validate :customer_dress_measurement_belongs_to_customer_and_dress, if: -> { customer_dress_measurement.present? }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # Nested attributes
  accepts_nested_attributes_for :order_item_stitch_features, allow_destroy: true, reject_if: :invalid_stitch_feature_attributes
  accepts_nested_attributes_for :customer_dress_measurement

  # Callbacks
  before_create :set_order_item_details
  after_update :update_order_total, if: :price_or_quantity_changed?
  after_destroy :update_order_total

  def self.ransackable_associations(auth_object = nil)
    ["customer_dress_measurement", "dress", "garment_type", "member", "order", "order_item_stitch_features", "order_measurements", "stitch_features", "worker"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["completion_date", "created_at", "customer_dress_measurement_id", "delivery_date", "dress_id", "function_date", "garment_type_id", "id", "id_value", "is_urgent", "last_visited_screen", "measurement_dress_given", "member_id", "name", "order_id", "order_item_number", "price", "quantity", "special_instruction", "status", "stichfor", "trial_date", "updated_at", "video_link", "work_type", "worker_id"]
  end

  def order_status
    return 'pending_assign' if status == 'accepted' && worker.nil?
    return 'pending' if status == 'accepted' && worker.present?
    status
  end

  def customer
    order.customer
  end

  private

  def date_validation
    %i[delivery_date trial_date function_date completion_date].each do |field|
      date_value = send(field)
      next unless date_value.present? # Skip if date is blank

      if new_record? || send("#{field}_changed?") # Validate on create or if changed on update
        if date_value < Date.today
          errors.add(field, "can't be in the past")
        end
      end
    end
  end

  def video_link_format
    uri = URI.parse(video_link)
    # Check for HTTP or HTTPS scheme
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:video_link, 'must be a valid HTTP or HTTPS URL (e.g., https://example.com)')
      return # Exit if scheme fails
    end

    # Check if host exists and is a valid domain
    unless uri.host.present? && uri.host.match?(/\A[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])*)*\.[a-z]{2,}\z/i)
      errors.add(:video_link, 'must include a valid domain (e.g., example.com)')
    end
  rescue URI::InvalidURIError
    errors.add(:video_link, 'is not a valid URL')
  end

  def video_link_present?
    video_link.present?
  end

  def set_order_item_details
    self.order_item_number = generate_order_item_number
    self.status = :accepted
  end

  def generate_order_item_number
    prefix = order.order_number

    # Fetch all order items for the current order
    order_item_numbers = order.order_items.pluck(:order_item_number)

    # Extract numeric parts and find the highest number
    next_id = order_item_numbers.compact.map { |no| no.split('-').last.to_i }.max.to_i + 1

    "#{prefix}-#{next_id}"
  end

  def price_or_quantity_changed?
    saved_change_to_price? || saved_change_to_quantity?
  end

  def update_order_total
    order.update_total
  end

  def invalid_stitch_feature_attributes(attributes)
    # Allow existing records (with id) to be updated, even if empty
    return false if attributes[:id].present?

    stitch_feature_id = attributes[:stitch_feature_id]
    return true if stitch_feature_id.blank?

    stitch_feature = StitchFeature.find_by(id: stitch_feature_id)
    return true unless stitch_feature && dress.stitch_features.include?(stitch_feature)

    # Skip creating new records if attributes are empty
    case stitch_feature.value_selection_type
    when 'radio', 'multiple'
      attributes[:stitch_option_ids].blank? || attributes[:stitch_option_ids].empty?
    when 'textbox'
      attributes[:text_value].blank? || attributes[:text_value].strip.empty?
    else
      true
    end
  end

  def customer_dress_measurement_belongs_to_customer_and_dress
    if customer_dress_measurement.customer_id != customer.id || customer_dress_measurement.dress_id != dress_id
      errors.add(:customer_dress_measurement, "must match order item customer and dress")
    end
  end
end
