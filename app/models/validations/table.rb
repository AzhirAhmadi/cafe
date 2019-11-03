module  Validations::Table
    def self.included base
        base.class_eval do
            validates :capacity, :table_number, :event, :board_game ,presence: true

            include ModelValidate::Table

            validate :active_event, :active_board_game
        end
    end
end