class WalletTransaction < ApplicationRecord
  include Auditable

  belongs_to :wallet
  belongs_to :order, foreign_key: :reference_id, primary_key: :id, optional: true

  enum :transaction_type, { credit: 0, debit: 1 }
  enum :status, { pending: 0, success: 1, failed: 2 }
end
