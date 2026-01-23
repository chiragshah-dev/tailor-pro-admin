class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_paper_trail_whodunnit
  before_action :set_audit_context

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

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || admin_root_path)
  end
end
