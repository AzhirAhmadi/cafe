module ModelValidate::Table
    def active_event
        errors.add(:event, "is not active") unless  event&.active?
    end

    def active_board_game
        errors.add(:board_game, "is not active") unless  board_game&.active?
    end

    def board_game_owner_ship
        errors.add(:board_game, "is not owened by this coffe_shop") unless  board_game&.creator&.id == event&.coffee_shop&.id
    end
end