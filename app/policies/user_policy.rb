class UserPolicy < ApplicationPolicy
  # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
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
    false
  end
end