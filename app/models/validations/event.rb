module  Validations::Event
    def self.included base
        base.class_eval do
            validates :name, :description, :opens_at,
            :enrol_start_time, :enrol_end_time, :event_start_time,
            :event_end_time, :closed_at , :coffee_shop, presence: true

            include ModelValidate::Event

            validate :active_coffee_shop, :time_orders
        end
    end
end