# app/controllers/admin/tailor_enquiries_controller.rb
class Admin::TailorEnquiriesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_tailor_enquiry, only: [:show, :destroy]

  def index
    @tailor_enquiries = TailorEnquiry.order(created_at: :desc)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @tailor_enquiries = @tailor_enquiries.where(
        "name ILIKE :search OR email ILIKE :search",
        search: search,
      )
    end

    @tailor_enquiries = @tailor_enquiries.page(params[:page]).per(10)
  end

  def show
  end

  def destroy
    @tailor_enquiry.destroy
    redirect_to admin_tailor_enquiries_path(page: params[:page]),
                notice: "Enquiry was successfully deleted."
  end

  private

  def set_tailor_enquiry
    @tailor_enquiry = TailorEnquiry.find(params[:id])
  end
end
