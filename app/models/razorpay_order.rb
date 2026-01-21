class RazorpayOrder < ApplicationRecord
  belongs_to :wallet

  validates :razorpay_order_id, presence: true, uniqueness: true
  validates :amount, numericality: { greater_than: 0 }

  scope :pending, -> { where(status: "created") }
  scope :attempted, -> { where(status: %w[attempted]) }
  scope :succeeded, -> { where(status: "paid") }
  scope :failed, -> { where(status: "failed") }

  def self.find_by_razorpay_id!(order_id)
    find_by!(razorpay_order_id: order_id)
  end
end
