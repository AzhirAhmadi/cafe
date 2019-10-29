module  Validations::BoardGame
    def self.included base
        base.class_eval do
            validates :name, :publisher, :min_player, :max_player, :play_time, presence: true
            validates :name, uniqueness: { scope: :creator_id}
        
            include ModelValidate::BoardGame
            validate :active_creator
        end
    end
end