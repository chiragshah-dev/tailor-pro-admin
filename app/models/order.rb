class Order < ApplicationRecord
  enum :status, {
    accepted: 0, in_progress: 1, pending_assign: 2, pending: 3, completed: 4, ready_for_trial: 5, delivered: 6, cancelled: 7
  }

  # Associations
  belongs_to :customer
  belongs_to :store
  belongs_to :worker, optional: true, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :order_measurements, dependent: :destroy
  accepts_nested_attributes_for :order_measurements, allow_destroy: true
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many_attached :images
  has_one_attached :voice_note

  # Validations
  validates :order_number, uniqueness: { scope: :store_id }
  validates :status, :order_date, presence: true, on: :update
  validates :courier_to_customer, inclusion: {
    in: [true, false], message: "must be true or false"
  }, on: :update
  validate :order_date_validation
  validate :custom_order_number_validation, on: :update, if: -> { order_number_format == 'custom' && order_number_changed? }

  # Callbacks
  before_create :set_order_details

  def self.ransackable_attributes(auth_object = nil)
    ["balance_due", "courier_to_customer", "created_at", "customer_id", "discount", "id", "id_value", "order_date", "order_number", "payment_received", "status", "store_id", "total_bill_amount", "updated_at", "worker_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "order_measurements", "store", "worker"]
  end

  def update_total
    # Update the order's total bill amount
    total = calculate_total
    balance_due = total - payment_received - discount
    update(total_bill_amount: total, balance_due: balance_due)
  end

  def user
    store.user
  end

  def order_status
    return 'pending_assign' if status == 'accepted' && worker.nil?
    return 'pending' if status == 'accepted' && worker.present?
    status
  end

  private

  def order_date_validation
    if order_date.present? && order_date > Date.today
      errors.add(:order_date, "can't be in future")
    end
  end

  def set_order_details
    self.order_number = generate_order_number
    self.order_date = Date.today
    self.status = :accepted
    self.total_bill_amount = calculate_total
    self.payment_received = 0
    self.discount = 0
    self.balance_due = total_bill_amount - payment_received - discount
  end

  def generate_order_number
    if order_number_format == 'serial'
      last_number = store.orders.where("order_number ~ '^[0-9]+$'")
                         .pluck(:order_number)
                         .map(&:to_i)
                         .max.to_i

      last_number + 1
    else
      loop do
        number = SecureRandom.hex(4).upcase
        break number unless store.orders.exists?(order_number: number)
      end
    end
  end

  def calculate_total
    order_items.sum { |item| (item.price || 0) * (item.quantity || 1) }
  end

  def order_number_format
    user&.setting&.order_number_format || 'random'
  end

  def custom_order_number_validation
    unless order_number =~ /[a-zA-Z]/
      errors.add(:order_number, "must contain at least one alphabetical character")
    end
  end
end
