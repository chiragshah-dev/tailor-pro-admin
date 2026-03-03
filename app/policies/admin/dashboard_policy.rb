# app/policies/dashboard_policy.rb
class Admin::DashboardPolicy < Struct.new(:user, :dashboard)
  def index?
    user.has_role?(:super_admin) || user.has_role?(:manager)
  end
end
