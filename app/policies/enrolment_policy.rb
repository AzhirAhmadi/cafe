class EnrolmentPolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def create?
    return false if current_user.blank?
    true
  end

  def destroy?
    return false if current_user.blank?
    true
  end

  class Scope < Scope
    def resolve
      scope.active_enrolments.all.order("id")
    end
  end
  
  private
    def enrolment
      data
    end
end