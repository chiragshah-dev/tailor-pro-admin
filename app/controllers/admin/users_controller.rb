class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  def index
    @users = User.order(created_at: :desc)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @users = @users.where(
        "name ILIKE :search OR email ILIKE :search OR contact_number ILIKE :search",
        search: search,
      )
    end

    @users = @users.order(:id).page(params[:page]).per(10)
  end

  def show
    @stores = @user.stores.order(is_main_store: :desc, created_at: :asc)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: "User was successfully created."
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :contact_number)
  end
end
