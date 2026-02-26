class Admin::ContactInfosController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_contact_info, only: [:show, :history, :destroy, :edit, :update]

  def index
    @contact_infos = ContactInfo.all

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @contact_infos = @contact_infos.where(
        "contact_number ILIKE :search OR email ILIKE :search OR website_url ILIKE :search OR address ILIKE :search",
        search: search,
      )
    end

    @contact_infos = @contact_infos.page(params[:page]).per(10)
  end

  def new
    @contact_info = ContactInfo.new
  end

  def create
    @contact_info = ContactInfo.new(contact_info_params)
    if @contact_info.save
      redirect_to admin_contact_infos_path, notice: "Contact info was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contact_info.update(contact_info_params)
      redirect_to admin_contact_infos_path(page: params[:page]), notice: "Contact info was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @contact_info.destroy
    redirect_to admin_contact_infos_path(page: params[:page]), notice: "Contact info was successfully deleted."
  end

  private

  def set_contact_info
    @contact_info = ContactInfo.find(params[:id])
  end

  def contact_info_params
    params.require(:contact_info).permit(:contact_number, :email, :website_url, :address)
  end
end
