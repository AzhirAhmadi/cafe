module  Validations::Table
    def self.included base
        base.class_eval do
            validates :capacity, :table_code, :event, :board_game ,presence: true
            validates :table_code, uniqueness: { scope: :event_id}
            include ModelValidate::Table

            validate :active_event, :active_board_game, :board_game_owner_ship, :board_game_capacity
        end
    end
end