class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user # current_admin_user
    @record = record
  end

  # ✅ Allow basic access for authenticated admins
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present?
  end

  def edit?
    update?
  end

  def destroy?
    user.present?
  end

  # ✅ Scope
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
