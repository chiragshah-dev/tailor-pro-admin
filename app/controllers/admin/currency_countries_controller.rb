class Admin::CurrencyCountriesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_currency_country, only: %i[show edit update destroy]

  def index
    @currency_countries =
      CurrencyCountry
        .includes(:currency)
        .references(:currency)
        .order(created_at: :desc)

    if params[:search].present?
      q = "%#{params[:search]}%"

      @currency_countries = @currency_countries.where(
        "currency_countries.country_name ILIKE :q
       OR currency_countries.country_code ILIKE :q
       OR currencies.name ILIKE :q",
        q: q,
      )
    end

    @currency_countries = @currency_countries.page(params[:page]).per(10)
  end

  def new
    @currency_country = CurrencyCountry.new
  end

  def create
    @currency_country = CurrencyCountry.new(currency_country_params)
    if @currency_country.save
      redirect_to admin_currency_countries_path, notice: "Currency country was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @country_code already loaded
  end

  def edit
  end

  def update
    if @currency_country.update(currency_country_params)
      redirect_to admin_currency_countries_path(page: params[:page]), notice: "Currency country was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @currency_country.destroy
    redirect_to admin_currency_countries_path(page: params[:page]), notice: "Currency country was successfully deleted."
  end

  private

  def set_currency_country
    @currency_country = CurrencyCountry.find(params[:id])
  end

  def currency_country_params
    params.require(:currency_country).permit(:country_name, :country_code, :currency_id)
  end
end
