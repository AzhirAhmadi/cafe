class CoffeeShopPolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
    def create?
      return true if current_user.sys_admin? || current_user.sys_master?
      super
    end

    def update?
      return true if data.owner_id == current_user.id
      return true if data.maintainer_id == current_user.id
      return true if current_user.sys_admin? || current_user.sys_master?
      super
    end

    def deactivate?
      return true if data.owner_id == current_user.id
      return true if data.id == current_user.id
      return true if current_user.sys_admin? || current_user.sys_master?
      super
    end

    class Scope < Scope
      def resolve
        if current_user&.sys_admin? || current_user&.sys_master?
          return scope.all
        end
        scope.where(deleted_at: nil)
      end
    end
  end