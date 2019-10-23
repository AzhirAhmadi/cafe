class BoardGamePolicy < ApplicationPolicy
    # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  def create?
    return true if current_user.coffee_owner? && board_game.creator.owner.id == current_user.id
  end

  def update?
    return true if current_user.coffee_owner? && board_game.creator.owner.id == current_user.id
  end

  def deactivate?
    return true if current_user.coffee_owner? && board_game.creator.owner.id == current_user.id
  end

  private
    def board_game
      data
    end
end