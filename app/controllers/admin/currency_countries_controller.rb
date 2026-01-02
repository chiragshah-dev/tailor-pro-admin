class Admin::CurrencyCountriesController < ApplicationController
  before_action :set_currency

  def new
    @currency_country = @currency.currency_countries.new
  end

  def create
    @currency_country = @currency.currency_countries.new(currency_country_params)

    if @currency_country.save
      redirect_to admin_currency_path(@currency),
                  notice: "Country mapping added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    country = @currency.currency_countries.find(params[:id])
    country.destroy

    redirect_to admin_currency_path(@currency),
                notice: "Country mapping removed."
  end

  private

  def set_currency
    @currency = Currency.find(params[:currency_id])
  end

  def currency_country_params
    params.require(:currency_country).permit(:country_code, :country_name)
  end
end
