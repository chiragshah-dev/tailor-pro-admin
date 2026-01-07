class Admin::MeasurementFieldsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_measurement_field, only: [:show, :edit, :update, :destroy]

  def index
    @measurement_fields = MeasurementField.includes(:garment_type)
    
    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @measurement_fields = @measurement_fields.where(
        "label ILIKE :search OR name ILIKE :search",
        search: search,
      )
    end

    @measurement_fields = @measurement_fields.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @measurement_field = MeasurementField.new
  end

  def create
    @measurement_field = MeasurementField.new(measurement_field_params)

    if @measurement_field.save
      redirect_to admin_measurement_fields_path(@measurement_field, page: params[:page]),
        notice: "Measurement Field created successfully."
    else
      flash.now[:alert] = "Measurement Field could not be created. Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @measurement_field.update(measurement_field_params)
      redirect_to admin_measurement_fields_path(@measurement_field, page: params[:page]),
        notice: "Measurement Field updated successfully."
    else
      flash.now[:alert] = "Measurement Field could not be updated. Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @measurement_field.destroy
      redirect_to admin_measurement_fields_path(page: params[:page]),
        notice: "Measurement Field deleted successfully."
    else
      redirect_to admin_measurement_fields_path(page: params[:page]),
        alert: "Measurement Field could not be deleted."
    end
  end

  private

  def set_measurement_field
    @measurement_field = MeasurementField.find(params[:id])
  end

  def measurement_field_params
    params.require(:measurement_field).permit(:label, :active, :measurement_image, :garment_type_id)
  end


end