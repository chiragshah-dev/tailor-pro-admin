class Admin::SystemNotificationsController < ApplicationController
  include AuditableHistory
  before_action :authenticate_admin_user!
  before_action :set_system_notification, only: [:show, :destroy, :edit, :update]

  def index
    @system_notifications = SystemNotification.order(created_at: :desc)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @system_notifications = @system_notifications.where(
        "title ILIKE :search OR message ILIKE :search",
        search: search,
      )
    end

    @system_notifications = @system_notifications.page(params[:page]).per(10)
  end

  def new
    @system_notification = SystemNotification.new
  end

  def create
    @system_notification = SystemNotification.new(system_notification_params)
    if @system_notification.save
      redirect_to admin_system_notifications_path(
                    page: params[:page],
                    search: params[:search],
                  ),
                  notice: "System notification created successfully."
    else
      flash.now[:alert] = "System notification could not be created. Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @system_notification.update(system_notification_params)
      redirect_to admin_system_notifications_path(
                    page: params[:page],
                    search: params[:search],
                  ),
                  notice: "System notification updated successfully."
    else
      flash.now[:alert] = "System notification could not be updated. Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @system_notification.destroy
    redirect_to admin_system_notifications_path(page: params[:page]),
                notice: "System notification was successfully deleted."
  end

  private

  def set_system_notification
    @system_notification = SystemNotification.find(params[:id])
  end

  def system_notification_params
    params.require(:system_notification).permit(:title, :message, :is_active)
  end
end
