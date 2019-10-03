class UserPolicy < ApplicationPolicy
  def create?
    puts User.role_power @requesting_user
    puts User.role_power data
    (User.role_power @requesting_user) > (User.role_power data)
  end

  # def update?
  #   puts User.role_power @requesting_user
  #   puts User.role_power data
  #   (User.role_power @requesting_user)-1 > (User.role_power data)
  # end
end