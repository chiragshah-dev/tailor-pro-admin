class Admin::OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show]
  before_action :authenticate_admin_user!

  def show
  end

  private

  def set_order_item
    @order_item = OrderItem
      .includes(:order, :worker, :garment_type)
      .find(params[:id])
  end
end
