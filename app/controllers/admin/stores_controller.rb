class Admin::StoresController < ApplicationController
  before_action :set_store, only: %i[show edit update destroy]

  def index
    @stores = Store.includes(:user)

    if params[:search].present?
      q = "%#{params[:search]}%"
      @stores = @stores.where(
        "stores.name ILIKE :q OR stores.code ILIKE :q OR stores.contact_number ILIKE :q",
        q: q
      )
    end

    @stores = @stores.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @store = Store.new
    @store.build_store_bank_detail
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      redirect_to admin_store_path(@store), notice: "Store was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @store already loaded
  end

  def edit
    @store.build_store_bank_detail if @store.store_bank_detail.blank?
  end

  def update
    if @store.update(store_params)
      redirect_to admin_store_path(@store), notice: "Store was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @store.destroy
    redirect_to admin_stores_path, notice: "Store was successfully deleted."
  end

  private

  def set_store
    @store = Store
      .includes(:user, :store_bank_detail)
      .find(params[:id])
  end

  def store_params
    params.require(:store).permit(
      :name, :code, :stitches_for,
      :contact_number, :email,
      :location_name, :address, :city, :state,
      :country, :postal_code,

      # GST
      :gst_number, :gst_name, :gst_percentage,
      :gst_included_on_bill, :gst_skipped,

      # Bank (nested)
      store_bank_detail_attributes: [
        :id,
        :account_holder_name,
        :bank_name,
        :account_number,
        :ifsc_code,
        :upi_id,
        :qr_code
      ]
    )
  end
end
