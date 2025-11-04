module Admin
  class AdminUserPolicy < ApplicationPolicy
    def index?
      user.has_role?(:super_admin) || user.has_role?(:manager)
    end

    def show?
      user.has_role?(:super_admin) || user.has_role?(:manager)
    end

    def create?
      user.has_role?(:super_admin)
    end

    def update?
      user.has_role?(:super_admin)
    end

    def destroy?
      user.has_role?(:super_admin)
    end
  end
end
