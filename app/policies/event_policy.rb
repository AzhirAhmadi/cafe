class EventPolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def create?
    return true if  current_user.coffee_owner? && event.coffee_shop.owner.id == current_user.id
    return true if  current_user.sys_expert? && event.coffee_shop.maintainer.id == current_user.id
    return true if  current_user.sys_admin? || current_user.sys_master?
  end

  def update?
    return true if  current_user.coffee_owner? && event.coffee_shop.owner.id == current_user.id
    return true if  current_user.sys_expert? && event.coffee_shop.maintainer.id == current_user.id
    return true if  current_user.sys_admin? || current_user.sys_master?
  end

  def deactivate?
    return true if  current_user.coffee_owner? && event.coffee_shop.owner.id == current_user.id
    return true if  current_user.sys_expert? && event.coffee_shop.maintainer.id == current_user.id
    return true if  current_user.sys_admin? || current_user.sys_master?
  end


  private
    def event
      data
    end
end