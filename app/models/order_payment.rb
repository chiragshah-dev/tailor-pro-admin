class OrderPayment < ApplicationRecord
  belongs_to :order

  enum :payment_method, { cash: 0, online: 1 }

  enum :payment_type, { received_pending_amount: 0, partially_waiving_off: 1, full_waving_amount: 2 }
end
