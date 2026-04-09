class Admin::SubscriptionPackagesController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_subscription_package, only: %i[show edit update destroy toggle_active history]

  def index
    params.permit(:search, :page, :sort, :direction, :billing_type, :active)

    @subscription_packages = SubscriptionPackage.all

    if params[:search].present?
      q = "%#{params[:search].strip}%"
      @subscription_packages = @subscription_packages.where(
        "name ILIKE :q OR description ILIKE :q", q: q,
      )
    end

    if params[:billing_type].present?
      @subscription_packages = @subscription_packages.where(billing_type: params[:billing_type])
    end

    if params[:active].present?
      @subscription_packages = @subscription_packages.where(active: params[:active] == "true")
    end

    sortable_columns = {
      "name" => "subscription_packages.name",
      "price_month" => "subscription_packages.price_month",
      "price_year" => "subscription_packages.price_year",
      "invoice_fee_percent" => "subscription_packages.invoice_fee_percent",
      "active" => "subscription_packages.active",
    }

    sort_column = sortable_columns[params[:sort]] || "subscription_packages.created_at"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    @subscription_packages = @subscription_packages
      .order("#{sort_column} #{sort_direction}")
      .page(params[:page])
      .per(10)
  end

  def show; end

  def new
    @subscription_package = SubscriptionPackage.new
  end

  def create
    @subscription_package = SubscriptionPackage.new(subscription_package_params)
    if @subscription_package.save
      redirect_to admin_subscription_package_path(@subscription_package),
                  notice: "Subscription package was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subscription_package.update(subscription_package_params)
      redirect_to admin_subscription_package_path(@subscription_package, page: params[:page]),
                  notice: "Subscription package was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription_package.destroy
    redirect_to admin_subscription_packages_path(page: params[:page]),
                notice: "Subscription package was successfully deleted."
  end

  def toggle_active
    @subscription_package.update!(active: !@subscription_package.active)
    redirect_to admin_subscription_packages_path(page: params[:page]),
                notice: "Package #{@subscription_package.active? ? "activated" : "deactivated"} successfully."
  end

  def reorder
    params[:data_items].each_with_index do |id, index|
      SubscriptionPackage.where(id: id).update_all(position: index + 1)
    end

    render json: { success: true }
  end

  private

  def set_subscription_package
    @subscription_package = SubscriptionPackage.find(params[:id])
  end

  def subscription_package_params
    params.require(:subscription_package).permit(
      :name,
      :description,
      :price_month,
      :price_year,
      :currency,
      :billing_type,
      :invoice_fee_percent,
      :active,
      :best_choice,
      :razorpay_plan_id_monthly,
      :razorpay_plan_id_yearly,
      :ios_product_id_monthly,
      :ios_product_id_yearly,
      :icon
    )
  end
end
