class Wallet < ApplicationRecord
  belongs_to :store
  has_many :wallet_transactions, dependent: :destroy
  has_many :razorpay_orders, dependent: :destroy

  enum :wallet_status, { active: 0, suspended: 1 }
end
