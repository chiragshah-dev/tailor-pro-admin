class Admin::OrderItemsController < ApplicationController
  include AuditableHistory

  before_action :set_order_item, only: [:show, :history]
  before_action :authenticate_admin_user!

  def show
    measurements_page = params[:measurements_page]

    @order_measurements = @order_item
      .order_measurements
      .includes(:measurement_field, :member).order(created_at: :asc).page(measurements_page)
  end

  private

  def set_order_item
    @order_item = OrderItem
      .find(params[:id])
  end
end
