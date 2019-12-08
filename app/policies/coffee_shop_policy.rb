class CoffeeShopPolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
    def create?
      return true if current_user.sys_admin? || current_user.sys_master?
      super
    end

    def update?
      return true if coffee_shop.owner_id == current_user.id
      return true if coffee_shop.maintainer_id == current_user.id
      return true if current_user.sys_admin? || current_user.sys_master?
      super
    end

    def destroy?
      return true if coffee_shop.owner_id == current_user.id
      return true if coffee_shop.id == current_user.id
      return true if current_user.sys_admin? || current_user.sys_master?
      super
    end

    class Scope < Scope
      def resolve
        if current_user&.sys_admin? || current_user&.sys_master?
          return scope.all.order("id")
        end
        scope.where(deleted_at: nil).order("id")
      end
    end

    private
    def coffee_shop
      data
    end
  end