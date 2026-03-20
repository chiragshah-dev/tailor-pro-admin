class Admin::RolesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_role, only: %i[show edit update destroy]

  def index
    @roles = Role.includes(:admin_users).order(created_at: :desc)

    if params[:search].present?
      q = "%#{params[:search]}%"
      @roles = @roles.where("name ILIKE :q OR display_name ILIKE :q", q: q)
    end

    @roles = @roles.page(params[:page]).per(10)
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to admin_roles_path, notice: "Role was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @role.update(role_params)
      redirect_to admin_roles_path(page: params[:page]), notice: "Role was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @role.is_super_admin?
      redirect_to admin_roles_path, alert: "Super admin role cannot be deleted."
    else
      @role.destroy
      redirect_to admin_roles_path(page: params[:page]), notice: "Role was successfully deleted."
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :display_name, :is_super_admin)
  end
end
