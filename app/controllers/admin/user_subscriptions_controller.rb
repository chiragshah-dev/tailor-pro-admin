# app/controllers/admin/user_subscriptions_controller.rb
class Admin::UserSubscriptionsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_subscription, only: [:show]

  def index
    params.permit(:search, :status, :billing_cycle, :page, :sort, :direction)

    @subscriptions = UserSubscription.includes(:user, :subscription_package)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @subscriptions = @subscriptions.joins(:user).where("users.name ILIKE :search OR users.email ILIKE :search", search: search)
    end

    @subscriptions = @subscriptions.where(status: params[:status]) if params[:status].present?
    @subscriptions = @subscriptions.where(billing_cycle: params[:billing_cycle]) if params[:billing_cycle].present?

    sortable_columns = {
      "user" => "users.name",
      "package" => "subscription_packages.name",
      "status" => "user_subscriptions.status",
      "cycle" => "user_subscriptions.billing_cycle",
      "amount" => "user_subscriptions.paid_amount",
      "started" => "user_subscriptions.started_at",
      "expires" => "user_subscriptions.expires_at",
      "created" => "user_subscriptions.created_at",
    }

    sort_column = sortable_columns[params[:sort]] || "user_subscriptions.created_at"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    @subscriptions = @subscriptions
      .references(:user, :subscription_package) # Ensures joins work for sorting
      .order("#{sort_column} #{sort_direction}")
      .page(params[:page])
      .per(10)
  end

  def show
  end

  private

  def set_subscription
    @subscription = UserSubscription.includes(:user, :subscription_package).find(params[:id])
  end
end
