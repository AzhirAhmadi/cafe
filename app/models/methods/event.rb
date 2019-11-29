module  Methods::Event
    def self.included base
        base.class_eval do
            def started_event?
                event_start_time < Time.now
            end

            def self.PP
                Event.all.order(id: :asc).each do  |item|
                  puts item.as_json(:except => [
                    :created_at,
                    :updated_at,
                    :opens_at,
                    :enrol_start_time,
                    :enrol_end_time,
                    :event_start_time,
                    :event_end_time,
                    :closed_at
                    ])
                end
                return nil
            end
        end
    end
end