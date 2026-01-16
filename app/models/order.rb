class Order < ApplicationRecord
  enum :status, {
    pending: 0, in_progress: 1, ready_for_trial: 2, completed: 4, delivered: 5, cancelled: 6,
  }

  enum :payment_status, { unpaid: 0, paid: 1 }

  # Associations
  belongs_to :customer
  belongs_to :store
  belongs_to :worker, optional: true
  has_many :order_items, dependent: :destroy
  has_many :order_measurements, dependent: :destroy
  accepts_nested_attributes_for :order_measurements, allow_destroy: true
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many_attached :images
  has_one_attached :voice_note
  has_many :order_payments, dependent: :destroy


  # Validations
  validates :order_number, uniqueness: { scope: :store_id }
  validates :status, :order_date, presence: true, on: :update
  validates :courier_to_customer, inclusion: {
                                    in: [true, false], message: "must be true or false",
                                  }, on: :update
  validate :order_date_validation
  validate :custom_order_number_validation, on: :update, if: -> { order_number_format == "custom" && order_number_changed? }
  has_one_attached :invoice_pdf

  # Callbacks
  before_create :set_order_details

  def self.ransackable_attributes(auth_object = nil)
    ["balance_due", "courier_to_customer", "created_at", "customer_id", "discount", "id", "id_value", "order_date", "order_number", "payment_received", "status", "store_id", "total_bill_amount", "updated_at", "worker_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "order_measurements", "store", "worker"]
  end

  #scopes

  scope :active_orders, -> { where.not(status: [:cancelled, :delivered, :completed]) }

  scope :due_today, -> { where(delivery_date: Date.current) }

  scope :upcoming_due, -> { where(delivery_date: Date.today..7.days.from_now.to_date) }

  def update_total
    # Update the order's total bill amount
    total = calculate_total
    final_total = total - discount.to_f
    paid_amount = payment_received.to_f + advance_payment.to_f
    balance_due = final_total - paid_amount

    update(total_bill_amount: total, balance_due: balance_due)
  end

  def recalculate_order_totals
    total = calculate_total
    final_total = total - discount.to_f
    paid_amount = advance_payment.to_f

    self.total_bill_amount = total
    self.balance_due = final_total - paid_amount
    self.payment_status = balance_due <= 0 ? :paid : :unpaid
  end

  def add_payment!(amount)
    self.advance_payment = advance_payment.to_f + amount.to_f
    recalculate_order_totals
    save!
  end

  def user
    store.user
  end

  def order_status
    return status unless pending?

    worker.nil? ? "pending" : "pending"
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
    self.status = :pending
    self.total_bill_amount = calculate_total
    self.payment_received = advance_payment || 0
    self.discount = 0 if discount.nil?
    self.balance_due = total_bill_amount - payment_received - discount
    self.additional_price = 0 if additional_price.nil?
    self.payment_status = balance_due <= 0 ? :paid : :unpaid
  end

  def generate_order_number
    if order_number_format == "serial"
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
    items_total = order_items.sum { |item| (item.price || 0) * (item.quantity || 1) }
    items_total + (additional_price || 0)
  end

  def order_number_format
    user.setting.order_number_format
  end

  def custom_order_number_validation
    unless order_number =~ /[a-zA-Z]/
      errors.add(:order_number, "must contain at least one alphabetical character")
    end
  end
end
