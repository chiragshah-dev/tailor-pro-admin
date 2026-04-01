# app/policies/application_policy.rb
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Dynamically handles any action? method
  # index?, show?, close?, bulk_delete?, history? — all work automatically
  def method_missing(method_name, *args)
    if method_name.to_s.end_with?("?")
      action = method_name.to_s.delete_suffix("?")
      checker.can?(action, self.class::MODULE_NAME)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.end_with?("?") || super
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve = @scope.all

    private attr_reader :user, :scope
  end

  private

  # Cached on user object - survives across multiple policy checks
  # in the same request, so DB is only hit twice total
  def checker
    user.instance_variable_get(:@_permission_checker) ||
      user.instance_variable_set(:@_permission_checker, PermissionChecker.new(user))
  end
end
