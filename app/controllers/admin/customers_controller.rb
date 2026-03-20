class Admin::CustomersController < ApplicationController
  include AuditableHistory
  before_action :authenticate_admin_user!
  before_action :set_customer, only: [:show, :history]

  # def index
  #   # @customers = Customer
  #   #   .left_joins(:store)
  #   #   .includes(:store)

  #   # to avoid separate queries for showing counts
  #   @customers = Customer
  #     .left_joins(:store)
  #     .left_joins(:members)
  #     .left_joins(:orders).includes(:store)
  #     .select(
  #       "customers.*,
  #      COUNT(DISTINCT members.id) AS members_count,
  #      COUNT(DISTINCT orders.id)  AS orders_count"
  #     )
  #     .group("customers.id", "stores.id")

  #   if params[:search].present?
  #     search = "%#{params[:search].strip}%"
  #     @customers = @customers.where(
  #       "customers.name ILIKE :search
  #        OR customers.contact_number ILIKE :search
  #        OR stores.name ILIKE :search",
  #       search: search,
  #     )
  #   end

  #   @customers = @customers.order(created_at: :desc).page(params[:page]).per(10)
  # end
  def index
    params.permit(:search, :page, :sort, :direction)

    @customers = Customer
      .left_joins(store_customers: :store)
      .left_joins(:members)
      .left_joins(:orders)
      .includes(store_customers: :store)
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

    sortable_columns = {
      "name" => "customers.name",
      "store" => "stores.name",
      "members" => "members_count",
      "orders" => "orders_count",
      "created_at" => "customers.created_at",
    }

    sort_column = sortable_columns[params[:sort]] || "customers.created_at"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    @customers = @customers
      .order("#{sort_column} #{sort_direction}")
      .page(params[:page])
      .per(10)
  end

  def show
    @members = @customer.members.page(params[:member_page]).per(5)
    @orders = @customer.orders
                       .includes(:order_items)
                       .order(created_at: :desc)
                       .page(params[:order_page])
                       .per(5)
  end

  private

  def set_customer
    @customer = Customer.includes(:stores).find(params[:id])
  end
end
