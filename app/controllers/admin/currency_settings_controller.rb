# app/controllers/admin/currency_settings_controller.rb
module Admin
  class CurrencySettingsController < ApplicationController
    before_action :set_currency_setting, only: %i[edit update destroy]

    def index
      @currency_settings = CurrencySetting.order(:country).page(params[:page]).per(10)
    end

    def new
      @currency_setting = CurrencySetting.new
    end

    def create
      @currency_setting = CurrencySetting.new(currency_setting_params)
      if @currency_setting.save
        redirect_to admin_currency_settings_path, notice: "Currency setting created successfully."
      else
        render :new
      end
    end

    def edit; end

    def update
      if @currency_setting.update(currency_setting_params)
        redirect_to admin_currency_settings_path, notice: "Currency setting updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @currency_setting.destroy
      redirect_to admin_currency_settings_path, notice: "Currency setting removed."
    end

    private

    def set_currency_setting
      @currency_setting = CurrencySetting.find(params[:id])
    end

    def currency_setting_params
      params.require(:currency_setting).permit(:country, :currency_code, :amount_limit)
    end
  end
end
