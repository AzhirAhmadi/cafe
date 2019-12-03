module  Validations::BoardGame
    def self.included base
        base.class_eval do
            validates :name, :publisher, :min_player, :max_player, :play_time, presence: true
            validates :name, uniqueness: { scope: :coffee_shop_id}
        
            include ModelValidate::BoardGame
            validate :active_coffee_shop
        end
    end
end