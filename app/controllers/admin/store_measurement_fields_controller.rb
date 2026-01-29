class Admin::StoreMeasurementFieldsController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_store_measurement_field, only: [:show, :destroy]

  def index
    @store_measurement_fields =
      StoreMeasurementField
        .includes(:store, :garment_type)
        .order(created_at: :desc)

    if params[:store_id].present?
      @store_measurement_fields =
        @store_measurement_fields.where(store_id: params[:store_id])
    end

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @store_measurement_fields =
        @store_measurement_fields.where(
          "store_measurement_fields.name ILIKE :search
           OR store_measurement_fields.label ILIKE :search",
          search: search,
        )
    end

    @store_measurement_fields =
      @store_measurement_fields.order(:id).page(params[:page]).per(10)
  end

  def show
  end

  def destroy
    @store_measurement_field.destroy

    redirect_to admin_store_measurement_fields_path(
                  store_id: params[:store_id],
                  page: params[:page],
                ),
                notice: "Measurement field was successfully deleted."
  end

  private

  def set_store_measurement_field
    @store_measurement_field = StoreMeasurementField.find(params[:id])
  end
end
