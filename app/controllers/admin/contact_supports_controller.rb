class Admin::ContactSupportsController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_contact_support, only: [:show, :history, :close, :destroy]

  def index
    @contact_supports = ContactSupport.includes(:user).order(created_at: :desc)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @contact_supports = @contact_supports.where(
        "subject ILIKE :search OR body ILIKE :search OR email ILIKE :search",
        search: search,
      )
    end

    @contact_supports = @contact_supports.page(params[:page]).per(10)
  end

  def show
  end

  def close
    @contact_support.closed!
    redirect_to admin_contact_supports_path(page: params[:page]),
                notice: "Support request closed."
  end

  def destroy
    @contact_support.destroy
    redirect_to admin_contact_supports_path(page: params[:page]), notice: "Support request was successfully deleted."
  end

  private

  def set_contact_support
    @contact_support = ContactSupport.find(params[:id])
  end
end
