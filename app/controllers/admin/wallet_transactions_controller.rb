class Admin::WalletTransactionsController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_wallet_transaction, only: [:history]

  private

  def set_wallet_transaction
    @wallet_transaction = WalletTransaction.find(params[:id])
  end
end
