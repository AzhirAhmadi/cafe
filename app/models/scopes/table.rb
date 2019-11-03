module Scopes::Table
    def self.included base
        base.class_eval do
            # scope :active_events, -> {where(deleted_at: nil)}
            # scope :in_coffee_shop, -> (coffee_shop) {where("coffee_shop_id = ?", coffee_shop.id)}
        end
    end
end