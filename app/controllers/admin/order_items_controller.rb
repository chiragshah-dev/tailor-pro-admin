class Admin::OrderItemsController < ApplicationController
  include AuditableHistory

  before_action :set_order_item, only: [:show, :history]
  before_action :authenticate_admin_user!

  def show
  end

  def history
    load_audit_history(@order_item)
  end

  private

  def set_order_item
    @order_item = OrderItem
      .includes(:order, :worker, :garment_type)
      .find(params[:id])
  end
end
