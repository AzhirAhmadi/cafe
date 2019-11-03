module Scopes::Table
    def self.included base
        base.class_eval do
            scope :active_tables, -> {where(deleted_at: nil)}
            scope :unlocked_tables, -> {Table.joins(:event).where("events.opens_at < ?", Time.now)}
            scope :in_coffee_shop, -> (coffee_shop) {Table.joins(:event).where("events.coffee_shop_id = ?", coffee_shop.id)}
            scope :in_event, -> (event) {where("event_id = ?", event.id)}
        end
    end
end