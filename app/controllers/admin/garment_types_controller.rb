class Admin::GarmentTypesController < ApplicationController
  include AuditableHistory
  before_action :authenticate_admin_user!
  before_action :set_garment_type, only: %i[show edit update destroy history]
  before_action :load_measurements, only: %i[new edit create update new_garment_type_combo]

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

    @garment_types = GarmentType
      .includes(:image_attachment, :combo_items)

    if params[:search].present?
      q = params[:search].strip

      @garment_types = @garment_types.where(
        "garment_name ILIKE :q OR gender = :gender",
        q: "%#{q}%",
        gender: GarmentType.genders[q.downcase],
      )
    end

    sortable_columns = {
      "garment_name" => "garment_name",
      "gender" => "gender",
      "active" => "active",
      "created_at" => "created_at",
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
    @combo_items = []
    @measurement_fields = []

    if @garment_type.combo?
      @combo_items = @garment_type.combo_items.includes(:measurement_fields)
    else
      @measurement_fields = @garment_type.measurement_fields.where(active: true)
    end
  end

  def new
    @garment_type = GarmentType.new
    load_garments
  end

  def edit
    load_garments
  end

  def create
    ActiveRecord::Base.transaction do
      @garment_type = GarmentType.new(garment_type_params)
      @garment_type.save!

      update_measurements
      update_combo_children
    end

    redirect_to admin_garment_types_path,
                notice: "Garment type created successfully"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    ActiveRecord::Base.transaction do
      @garment_type.update!(garment_type_params)

      update_measurements
      update_combo_children
    end

    redirect_to admin_garment_types_path(page: params[:page]),
                notice: "Garment type updated successfully"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @garment_type.garment_type_measurements.destroy_all
    @garment_type.destroy
    redirect_to admin_garment_types_path(page: params[:page]),
                notice: "Garment type deleted."
  end

  def new_garment_type_combo
    @garment_type = GarmentType.new(garment_type: "combo")
    @selected_child_ids = []
    load_measurements
    load_garments
  end

  def edit_combo
    @garment_type = GarmentType.find(params[:id])
    @single_garments = GarmentType
      .single
      .where(active: true)
      .order(:garment_name)

    load_garments
  end

  def update_combo
    @garment_type = GarmentType.find(params[:id])

    ActiveRecord::Base.transaction do
      @garment_type.update!(garment_type_params)

      update_combo_children
    end

    redirect_to admin_garment_type_path(@garment_type),
                notice: "Combo updated successfully"
  rescue ActiveRecord::RecordInvalid
    load_garments
    render :edit_combo
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
      :garment_type,
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
        sequence: sequences[mid].presence,
      )
    end
  end

  def update_combo_children
    return unless @garment_type.combo?

    selected_ids = params[:child_ids] || []

    @garment_type.combo_garments.destroy_all

    combo_rows = selected_ids.map do |id|
      { combo_id: @garment_type.id, garment_type_id: id }
    end

    ComboGarment.insert_all(combo_rows) if combo_rows.any?
  end

  def load_garments
    @single_garments = GarmentType
      .single
      .where(active: true)
      .order(:garment_name)
  end
end
