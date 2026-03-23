# app/controllers/admin/admin_users_controller.rb
class Admin::AdminUsersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_admin_user, only: %i[show edit update destroy]

  def index
    @admin_users = AdminUser.includes(:role).order(created_at: :desc)

    if params[:search].present?
      q = "%#{params[:search]}%"
      @admin_users = @admin_users
        .joins(:role)
        .where(
          "admin_users.email ILIKE :q OR roles.display_name ILIKE :q",
          q: q,
        )
    end

    @admin_users = @admin_users.page(params[:page]).per(10)
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to admin_accounts_path, notice: "Admin user was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if params[:admin_user][:password].blank?
      params[:admin_user].delete(:password)
      params[:admin_user].delete(:password_confirmation)
    end

    if @admin_user.update(admin_user_params)
      redirect_to admin_accounts_path(page: params[:page]), notice: "Admin user was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @admin_user == current_admin_user
      redirect_to admin_accounts_path, alert: "You cannot delete your own account."
      return
    end

    @admin_user.destroy
    redirect_to admin_accounts_path(page: params[:page]), notice: "Admin user was successfully deleted."
  end

  private

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation, :role_id)
  end
end
