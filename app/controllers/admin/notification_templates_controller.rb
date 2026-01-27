class Admin::NotificationTemplatesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_template, only: [:show, :edit, :update, :destroy]

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
    @template = NotificationTemplate.new
  end

  def create
    @template = NotificationTemplate.new(template_params)

    if @template.save
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
    if @template.update(template_params)
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
    if @template.destroy
      redirect_to admin_notification_templates_path(
                    page: params[:page],
                    search: params[:search],
                  ),
                  notice: "Notification template deleted successfully."
    else
      redirect_to admin_notification_template_path(
                    @template,
                    page: params[:page],
                    search: params[:search],
                  ),
                  alert: "Notification template could not be deleted."
    end
  end

  private

  def set_template
    @template = NotificationTemplate.find(params[:id])
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
