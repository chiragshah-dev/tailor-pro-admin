class Admin::UsersController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :history, :sessions, :session_detail]

  # def index
  #   @users = User.includes(:active_store).order(created_at: :desc)

  #   if params[:search].present?
  #     search = "%#{params[:search].strip}%"
  #     @users = @users.where(
  #       "name ILIKE :search OR email ILIKE :search OR contact_number ILIKE :search",
  #       search: search,
  #     )
  #   end

  #   @users = @users.order(:id).page(params[:page]).per(10)
  # end

  def index
    @users = User.includes(:active_store, :stores, active_user_subscription: :subscription_package)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @users = @users.where(
        "name ILIKE :search OR email ILIKE :search OR contact_number ILIKE :search",
        search: search,
      )
    end

    sortable_columns = %w[name email deleted]
    sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    @users = @users
      .order("#{sort_column} #{sort_direction}")
      .page(params[:page])
      .per(10)
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
      redirect_to admin_user_path(@user, page: params[:page]), notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user.soft_delete!
    redirect_to admin_users_path(page: params[:page]), notice: "User was successfully deleted."
  end

  def sessions
    @app_sessions = @user.app_sessions
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(10)
  end

  def session_detail
    @session = @user.app_sessions.find(params[:session_id])

    routes = @session.route_sequence || []

    @route_sequence = Kaminari.paginate_array(
      routes.reverse
    ).page(params[:route_page]).per(10)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :contact_number)
  end
end
