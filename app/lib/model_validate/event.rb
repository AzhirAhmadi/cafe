module ModelValidate::Event
    def active_coffee_shop
        errors.add(:coffee_shop, "is not active") unless  coffee_shop&.active?
    end

    def time_orders
        if errors.messages.empty?
            unless opens_at < enrol_start_time 
                errors.add(:opens_at ,"time is not correct") 
            end
            unless enrol_start_time < enrol_end_time 
                errors.add(:enrol_start_time ,"time is not correct")
            end
            unless enrol_end_time < event_start_time 
                errors.add(:enrol_end_time ,"time is not correct")
            end
            unless event_start_time < event_end_time 
                errors.add(:event_start_time ,"time is not correct")
            end
            unless event_end_time < closed_at
                errors.add(:event_end_time ,"time is not correct")
            end
        end
    end
end