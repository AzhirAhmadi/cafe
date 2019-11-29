class EnrolmentPolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def create?
    return false if current_user.blank?
    true
  end

  def deactivate?
    return false if current_user.blank?
    true
  end

  class Scope < Scope
    def resolve
      scope.all.order("id")
    end
  end
  
  private
    def enrolment
      data
    end
end