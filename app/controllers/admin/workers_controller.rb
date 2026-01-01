class Admin::WorkersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_worker, only: [:show, :edit, :update, :destroy]
  before_action :set_current_page, only: [:show, :edit, :update, :destroy]

  def index
    @workers = Worker.left_joins(:store, :job_role)
      .includes(:store, :job_role)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @workers = @workers.where(
        "workers.name ILIKE :search
       OR workers.contact_number ILIKE :search
       OR stores.name ILIKE :search
       OR job_roles.name ILIKE :search",
        search: search,
      )
    end

    @workers = @workers.order(:id).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)

    if @worker.save
      redirect_to admin_worker_path(@worker, page: params[:page], search: params[:search]),
        notice: "Worker created successfully."
    else
      flash.now[:alert] = "Worker could not be created. Please fix the errors below."
      render :new
    end
  end

  def edit
  end

  def update
    if @worker.update(worker_params)
      redirect_to admin_worker_path(@worker, page: @current_page, search: @search),
        notice: "Worker updated successfully."
    else
      flash.now[:alert] = "Worker could not be updated. Please fix the errors below."
      render :edit
    end
  end

  def destroy
    if @worker.destroy
      redirect_to admin_workers_path(page: @current_page, search: @search),
        notice: "Worker deleted successfully."
    else
      redirect_to admin_worker_path(@worker, page: @current_page, search: @search),
        alert: "Worker could not be deleted."
    end
  end

  private

  def set_worker
    @worker = Worker.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(
      :name,
      :contact_number,
      :job_role_id,
      :store_id
    )
  end

  def set_current_page
    @current_page = params[:page] || 1
    @search = params[:search]
  end
end
