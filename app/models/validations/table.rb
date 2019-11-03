module  Validations::Table
    def self.included base
        base.class_eval do
            validates :capacity, :table_code, :event, :board_game ,presence: true

            include ModelValidate::Table

            validate :active_event, :active_board_game, :board_game_owner_ship
        end
    end
end