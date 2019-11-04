module  Methods::Event
    def self.included base
        base.class_eval do
            def started_event?
                event_start_time < Time.now
            end
        end
    end
end