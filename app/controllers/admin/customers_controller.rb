class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    # @customers = Customer
    #   .left_joins(:store)
    #   .includes(:store)

    # to avoid separate queries for showing counts 
    @customers = Customer
      .left_joins(:store)
      .left_joins(:members)
      .left_joins(:orders).includes(:store)
      .select(
        "customers.*,
       COUNT(DISTINCT members.id) AS members_count,
       COUNT(DISTINCT orders.id)  AS orders_count"
      )
      .group("customers.id", "stores.id")

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @customers = @customers.where(
        "customers.name ILIKE :search
         OR customers.contact_number ILIKE :search
         OR stores.name ILIKE :search",
        search: search,
      )
    end

    @customers = @customers.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])

    @members = @customer.members.page(params[:member_page]).per(5)
    @orders = @customer.orders
                       .includes(:order_items)
                       .order(created_at: :desc)
                       .page(params[:order_page])
                       .per(5)
  end
end
