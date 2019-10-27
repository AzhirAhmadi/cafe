class UserPolicy < ApplicationPolicy
  # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def show?
    true
  end
  
  def create?
    return true unless has_current_user
    return true if data_is_lower_then_current_user
    super
  end

  def update?
    return false unless has_current_user   
    return true if data_is_for_current_user
    return true if data_is_lower_then_current_user
    super
  end

  def deactivate?
    return false unless has_current_user
    return true if data_is_for_current_user
    return true if data_is_lower_then_current_user
    super
  end

  class Scope < Scope
    def resolve
      if current_user.sys_admin?
        scope.where(deleted_at: nil).or(scope.where.not(role: [:sys_admin]))
      else
        scope.where(deleted_at: nil)
      end
    end
  end
end