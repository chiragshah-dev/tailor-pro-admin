module Admin
  class OrderPolicy < ApplicationPolicy
    def index?
      user.has_role?(:super_admin) || user.has_role?(:manager)
    end

    def show?
      index?
    end

    def create?
      user.has_role?(:super_admin)
    end

    def update?
      user.has_role?(:super_admin) || user.has_role?(:manager)
    end

    def destroy?
      user.has_role?(:super_admin)
    end

    class Scope < Scope
      def resolve
        if user.has_role?(:super_admin)
          scope.all
        elsif user.has_role?(:manager)
          scope.where(user_id: user.id)
        else
          scope.none
        end
      end
    end
  end
end
