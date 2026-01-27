class Admin::JobRolesController < ApplicationController
  include AuditableHistory
  before_action :authenticate_admin_user!
  before_action :set_job_role, only: [:show, :edit, :update, :destroy, :history]

  def index
    @job_roles = JobRole.all

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @job_roles = @job_roles.where("job_roles.name ILIKE :search", search: search)
    end

    @job_roles = @job_roles.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @job_role = JobRole.new
  end

  def create
    @job_role = JobRole.new(job_role_params)

    if @job_role.save
      redirect_to admin_job_roles_path(page: params[:page], search: params[:search]),
        notice: "Job role created successfully."
    else
      flash.now[:alert] = "Job role could not be created."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @job_role.update(job_role_params)
      redirect_to admin_job_roles_path(page: params[:page]),
        notice: "Job role updated successfully."
    else
      flash.now[:alert] = "Job role could not be updated."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @job_role.destroy
      redirect_to admin_job_roles_path(page: params[:page]),
        notice: "Job role deleted successfully."
    else
      redirect_to admin_job_role_path(@job_role, page: params[:page]),
        alert: "Job role could not be deleted."
    end
  end

  private

  def set_job_role
    @job_role = JobRole.find(params[:id])
  end

  def job_role_params
    params.require(:job_role).permit(:name)
  end
end
