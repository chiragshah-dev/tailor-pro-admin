# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :set_paper_trail_whodunnit
  before_action :set_audit_context
  before_action :authorize_admin_namespace
  before_action :check_permission

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_for_paper_trail
    current_admin_user ? "admin:#{current_admin_user.id}" : "admin_system"
  end

  def set_audit_context
    RequestStore.store[:path] = request.fullpath
    RequestStore.store[:method] = request.method
    RequestStore.store[:request_id] = request.request_id
  end

  private

  def check_permission
    return unless admin_controller?
    return if devise_controller?
    return unless current_admin_user

    # auto-derive module name from controller name
    # admin/orders → orders
    # admin/currency_countries → currency_countries
    module_name = controller_name

    unless PermissionChecker.new(current_admin_user).can?(action_name, module_name)
      raise Pundit::NotAuthorizedError
    end
  end

  def authorize_admin_namespace
    return unless admin_controller?
    return if devise_controller?
    require_admin_authentication
  end

  def admin_controller?
    self.class.name.start_with?("Admin::")
  end

  def require_admin_authentication
    unless admin_user_signed_in?
      redirect_to new_admin_user_session_path,
                  alert: "Please login to access this page."
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to request.referrer || admin_root_path
  end
end
