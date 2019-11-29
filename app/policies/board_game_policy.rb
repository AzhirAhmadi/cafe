class BoardGamePolicy < ApplicationPolicy
  # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def show?
    true
  end

  def index?
    true
  end

  def create?
    return true if current_user.coffee_owner? && board_game.coffee_shop.owner.id == current_user.id
    return true if current_user.sys_expert? && board_game.coffee_shop.maintainer.id == current_user.id
    return true if current_user.sys_admin? || current_user.sys_master?
  end

  def update?
    return true if current_user.coffee_owner? && board_game.coffee_shop.owner.id == current_user.id
    return true if current_user.sys_expert? && board_game.coffee_shop.maintainer.id == current_user.id
    return true if current_user.sys_admin? || current_user.sys_master?
  end

  def deactivate?
    return true if current_user.coffee_owner? && board_game.coffee_shop.owner.id == current_user.id
    return true if current_user.sys_expert? && board_game.coffee_shop.maintainer.id == current_user.id
    return true if current_user.sys_admin? || current_user.sys_master?
  end

  class Scope < Scope
    def resolve
      if current_user&.sys_admin? || current_user&.sys_master?
        return scope.all
      end
      scope.where(deleted_at: nil)
    end
  end

  private
    def board_game
      data
    end
end