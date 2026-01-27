class Admin::OrderItemsController < ApplicationController
  include AuditableHistory

  before_action :set_order_item, only: [:show, :history]
  before_action :authenticate_admin_user!

  def show
    @order_measurements = @order_item
      .order_measurements
      .includes(:measurement_field, :member)
  end

  private

  def set_order_item
    @order_item = OrderItem
      .find(params[:id])
  end
end
