class Admin::NotificationTemplatesController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_notification_template, only: [:show, :edit, :update, :destroy, :history]

  def index
    @templates = NotificationTemplate.all

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @templates = @templates.where(
        "key ILIKE :search
         OR title ILIKE :search
         OR body ILIKE :search",
        search: search,
      )
    end

    @templates = @templates.order(:id).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @notification_template = NotificationTemplate.new
  end

  def create
    @notification_template = NotificationTemplate.new(template_params)

    if @notification_template.save
      redirect_to admin_notification_templates_path(
                    page: params[:page],
                    search: params[:search],
                  ),
                  notice: "Notification template created successfully."
    else
      flash.now[:alert] = "Notification template could not be created. Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @notification_template.update(template_params)
      redirect_to admin_notification_templates_path(
                    page: params[:page],
                    search: params[:search],
                  ),
                  notice: "Notification template updated successfully."
    else
      flash.now[:alert] = "Notification template could not be updated. Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @notification_template.destroy
      redirect_to admin_notification_templates_path(
                    page: params[:page],
                    search: params[:search],
                  ),
                  notice: "Notification template deleted successfully."
    else
      redirect_to admin_notification_template_path(
                    @notification_template,
                    page: params[:page],
                    search: params[:search],
                  ),
                  alert: "Notification template could not be deleted."
    end
  end

  private

  def set_notification_template
    @notification_template = NotificationTemplate.find(params[:id])
  end

  def template_params
    params.require(:notification_template).permit(
      :key,
      :title,
      :body,
      :active
    )
  end
end
