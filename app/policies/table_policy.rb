class TablePolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def show?
    true
  end

  def index?
    true
  end

  def create?
    return true if  current_user.coffee_owner? && table.coffee_shop.owner.id == current_user.id
    return true if  current_user.sys_expert? && table.coffee_shop.maintainer.id == current_user.id
    return true if  current_user.sys_admin? || current_user.sys_master?
  end

  def update?
    return true if  current_user.coffee_owner? && table.coffee_shop.owner.id == current_user.id
    return true if  current_user.sys_expert? && table.coffee_shop.maintainer.id == current_user.id
    return true if  current_user.sys_admin? || current_user.sys_master?
  end

  def deactivate?
    return true if  current_user.coffee_owner? && table.coffee_shop.owner.id == current_user.id
    return true if  current_user.sys_expert? && table.coffee_shop.maintainer.id == current_user.id
    return true if  current_user.sys_admin? || current_user.sys_master?
  end

  class Scope < Scope
    def resolve
      return scope.all if current_user&.sys_admin? || current_user&.sys_master?
      return scope.active_tables if current_user&.coffee_owner? || current_user&.sys_expert?
      scope.active_tables.unlocked_tables
    end
  end
  
  private
    def table
      data
    end
end