class UserPolicy < ApplicationPolicy
  # enum role: [:sys_master, :sys_admin, :sys_expert, :cafe_owner,:player]
  def create?
    return true if has_current_user
    return true if data_is_lower_then_current_user
    super
  end

  def update?
    return true if data_is_for_current_user
    return false if has_current_user
    return true if data_is_lower_then_current_user
    super
  end

  def destroy?
    return true if data_is_for_current_user
    return false if has_current_user
    return true if data_is_lower_then_current_user
    super
  end
end