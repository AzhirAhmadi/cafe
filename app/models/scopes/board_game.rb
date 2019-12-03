module Scopes::BoardGame
    def self.included base
        base.class_eval do
            scope :in_coffee_shop, -> (coffee_shop) {where("coffee_shop_id = ?", coffee_shop.id)}
        end
    end
end