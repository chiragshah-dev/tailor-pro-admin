# app/controllers/admin/currency_settings_controller.rb
module Admin
  class CurrencySettingsController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_currency_setting, only: %i[edit update destroy]

    def index
      @currency_settings = CurrencySetting.includes(:currency).order(:created_at).page(params[:page]).per(10)
    end

    def new
      @currency_setting = CurrencySetting.new
    end

    def create
      @currency_setting = CurrencySetting.new(currency_setting_params)
      if @currency_setting.save
        redirect_to admin_currency_settings_path, notice: "Currency setting created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @currency_setting.update(currency_setting_params)
        redirect_to admin_currency_settings_path(page: params[:page]), notice: "Currency setting updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @currency_setting.destroy
      redirect_to admin_currency_settings_path(page: params[:page]), notice: "Currency setting removed."
    end

    private

    def set_currency_setting
      @currency_setting = CurrencySetting.find(params[:id])
    end

    def currency_setting_params
      params.require(:currency_setting).permit(:amount_limit, :currency_id, :commission_rate, :message)
    end
  end
end
