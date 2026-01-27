class Admin::OrderItemsController < ApplicationController
  include AuditableHistory

  before_action :set_order_item, only: [:show, :history]
  before_action :authenticate_admin_user!

  def show
  end

  private

  def set_order_item
    @order_item = OrderItem
      .find(params[:id])
  end
end
