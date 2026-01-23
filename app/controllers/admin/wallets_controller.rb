class Admin::WalletsController < ApplicationController
  include AuditableHistory
  before_action :authenticate_admin_user!
  before_action :set_wallet, only: [:show, :history]

  def index
    @wallets = Wallet.left_joins(:store).includes(:store)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @wallets = @wallets.where(
        "CAST(wallets.id AS TEXT) ILIKE :search
        OR CAST(wallets.balance AS TEXT) ILIKE :search
        OR wallets.currency ILIKE :search
        OR stores.name ILIKE :search
        OR stores.code ILIKE :search",
        search: search,
      )
    end

    @wallets = @wallets.order(balance: :desc).page(params[:page]).per(10)
  end

  def show
    @wallet_transactions = @wallet&.wallet_transactions
      .order(created_at: :desc)
      .page(params[:transaction_page]).per(5)
  end

  def history
    load_audit_history(@wallet)
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id])
  end
end
