class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_order, only: :show

  def index
    @orders = Order
      .includes(:customer, :store)
      .order(created_at: :desc)

    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    @orders = @orders.page(params[:page]).per(10)
  end

  def show
    @order = Order.find(params[:id])

    items_page = params[:items_page]

    @order_items = @order.order_items
                         .includes(:worker, :garment_type)
                         .order(created_at: :asc)
                         .page(items_page)
                         .per(10)
  end

  private

  def set_order
    @order = Order
      .includes(:customer, :store, :worker)
      .find(params[:id])
  end
end
