class BoardGamePolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def create?
    return true if current_user.coffee_owner? && board_game.creator.owner.id == current_user.id
    return true if current_user.sys_expert? && board_game.creator.maintainer.id == current_user.id
    return true if current_user.sys_admin?
  end

  def update?
    return true if current_user.coffee_owner? && board_game.creator.owner.id == current_user.id
    return true if current_user.sys_expert? && board_game.creator.maintainer.id == current_user.id
    return true if current_user.sys_admin?
  end

  def deactivate?
    return true if current_user.coffee_owner? && board_game.creator.owner.id == current_user.id
    return true if current_user.sys_expert? && board_game.creator.maintainer.id == current_user.id
    return true if current_user.sys_admin?
  end

  private
    def board_game
      data
    end
end