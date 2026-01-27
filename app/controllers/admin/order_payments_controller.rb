class Admin::OrderPaymentsController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_order
  before_action :set_order_payment, only: [:history]

  def index
    @payment_details = @order.order_payments

    if params[:search].present?
      query = "%#{params[:search].strip}%"

      @payment_details = @payment_details.where(
        "transaction_id ILIKE :q",
        q: query,
      )
    end

    if params[:payment_method].present?
      @payment_details = @payment_details.where(payment_method: params[:payment_method])
    end

    if params[:payment_type].present?
      @payment_details = @payment_details.where(payment_type: params[:payment_type])
    end

    @payment_details = @payment_details.page(params[:page]).per(10)
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_order_payment
    @order_payment = OrderPayment.find(params[:id])
  end
end
