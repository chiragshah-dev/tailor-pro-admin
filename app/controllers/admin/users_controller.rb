class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all

    if params[:search].present?
      search = "%#{params[:search]}%"
      @users = @users.where(
        "name ILIKE :search OR email ILIKE :search OR contact_number ILIKE :search",
        search: search,
      )
    end

    @users = @users.order(:id).page(params[:page]).per(5)
  end

  def show
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
    @user = @user = User.includes(:stores).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :contact_number)
  end
end
