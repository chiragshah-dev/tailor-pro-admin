class Admin::GarmentTypesController < ApplicationController
  include AuditableHistory
  before_action :authenticate_admin_user!
  before_action :set_garment_type, only: %i[show edit update destroy history]
  before_action :load_measurements, only: %i[new edit create update]

  # def index
  #   @garment_types = GarmentType.includes([:image_attachment])

  #   if params[:search].present?
  #     q = params[:search].strip

  #     @garment_types = @garment_types.where(
  #       "garment_name ILIKE :q OR gender = :gender",
  #       q: "%#{q}%",
  #       gender: GarmentType.genders[q.downcase],
  #     )
  #   end

  #   @garment_types = @garment_types
  #     .order(created_at: :desc)
  #     .page(params[:page])
  #     .per(10)
  # end

  def index
    params.permit(:search, :page, :sort, :direction)

    @garment_types = GarmentType.includes(:image_attachment)

    if params[:search].present?
      q = params[:search].strip

      @garment_types = @garment_types.where(
        "garment_name ILIKE :q OR gender = :gender",
        q: "%#{q}%",
        gender: GarmentType.genders[q.downcase]
      )
    end

    sortable_columns = {
      "garment_name" => "garment_name",
      "gender"       => "gender",
      "active"       => "active",
      "created_at"   => "created_at"
    }

    sort_column =
      sortable_columns[params[:sort]] || "created_at"

    sort_direction =
      params[:direction] == "asc" ? "asc" : "desc"

    @garment_types = @garment_types
                      .order("#{sort_column} #{sort_direction}")
                      .page(params[:page])
                      .per(10)
  end

  def show
    @measurement_fields =
      @garment_type
        .measurement_fields
        .where(active: true)
        .select("DISTINCT ON (label) measurement_fields.*")
        .order("label, id ASC")
  end

  def new
    @garment_type = GarmentType.new
  end

  def edit
  end

  def create
    @garment_type = GarmentType.new(garment_type_params)

    if @garment_type.save
      update_measurements
      redirect_to admin_garment_types_path,
                  notice: "Garment type created successfully"
    else
      render :new
    end
  end

  def update
    if @garment_type.update(garment_type_params)
      update_measurements
      redirect_to admin_garment_types_path(page: params[:page]),
                  notice: "Garment type updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @garment_type.garment_type_measurements.destroy_all
    @garment_type.destroy
    redirect_to admin_garment_types_path(page: params[:page]),
                notice: "Garment type deleted."
  end

  private

  def set_garment_type
    @garment_type = GarmentType.find(params[:id])
  end

  def garment_type_params
    params.require(:garment_type).permit(
      :garment_name,
      :gender,
      :active,
      :image
    )
  end

  def load_measurements
    @measurement_fields = MeasurementField
      .where(active: true)
      .select("DISTINCT ON (label) measurement_fields.*")
      .order("label, id ASC")
  end

  # def update_measurements
  #   return unless params[:measurement_field_ids]

  #   @garment_type.garment_type_measurements.destroy_all

  #   params[:measurement_field_ids].each do |mid|
  #     @garment_type.garment_type_measurements.create(
  #       measurement_field_id: mid,
  #     )
  #   end
  # end

  def update_measurements
    return unless params[:measurement_field_ids]

    sequences = params[:measurement_sequences] || {}

    @garment_type.garment_type_measurements.destroy_all

    params[:measurement_field_ids].each do |mid|
      @garment_type.garment_type_measurements.create(
        measurement_field_id: mid,
        sequence: sequences[mid].presence
      )
    end
  end
end
