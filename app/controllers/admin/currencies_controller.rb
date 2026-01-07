class Admin::CurrenciesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_currency, only: %i[show edit update destroy]

  def index
    @currencies = Currency.order(created_at: :desc)

    if params[:search].present?
      q = "%#{params[:search]}%"
      @currencies = @currencies.where(
        "currencies.name ILIKE :q",
        q: q
      )
    end

    @currencies = @currencies.page(params[:page]).per(10)
  end

  def new
    @currency = Currency.new
  end

  def create
    @currency = Currency.new(currency_params)
    if @currency.save
      redirect_to admin_currencies_path, notice: "Currency was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @currency already loaded
  end

  def edit
  end

  def update
    if @currency.update(currency_params)
      redirect_to admin_currencies_path(page: params[:page]), notice: "Currency was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @currency.destroy
    redirect_to admin_currencies_path(page: params[:page]), notice: "Currency was successfully deleted."
  end

  private

  def set_currency
    @currency = Currency.find(params[:id])
  end

  def currency_params
    params.require(:currency).permit(:name)
  end
end