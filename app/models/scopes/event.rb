module Scopes::Event
    def self.included base
        base.class_eval do
            scope :active_events, -> {where(deleted_at: nil)}
            scope :locked_events, -> {where("? < opens_at", Time.now)}
            scope :unlocked_events, -> {where("opens_at < ? ", Time.now)}
            scope :opened_events, -> {where("opens_at < ? AND ? < closed_at", Time.now, Time.now)}
            scope :closed_events, -> {where("closed_at < ?", Time.now)}
            scope :enroling_events, -> {where("enrol_start_time < ? AND ? < enrol_end_time", Time.now, Time.now)}
            scope :started_events, -> {where("event_start_time < ? AND ? < event_end_time", Time.now, Time.now)}

            scope :in_coffee_shop, -> (coffee_shop) {where("coffee_shop_id = ?", coffee_shop.id)}
        end
    end
end