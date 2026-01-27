class Admin::OrdersController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_order, only: [:show, :history]

  def index
    @orders = Order.left_joins(:customer, :store)
      .includes(:customer, :store)
      .order(created_at: :desc)

    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @orders = @orders.where(
        "
      orders.order_number ILIKE :search
      OR customers.name ILIKE :search
      OR customers.contact_number ILIKE :search
      OR stores.name ILIKE :search
      OR CAST(stores.code AS TEXT) ILIKE :search
    ",
        search: search,
      )
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
