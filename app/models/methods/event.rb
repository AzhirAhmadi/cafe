module  Methods::Event
    def self.included base
        base.class_eval do
            def started_event?
                event_start_time < Time.now
            end

            def isLocked?
                Time.now < opens_at
            end
            
            def isUnLocked?
                opens_at < Time.now
            end
            
            def isOpened?
                opens_at < Time.now && Time.now < closed_at
            end
            
            def isEnroling?
                enrol_start_time < Time.now && Time.now < enrol_end_time
            end
            
            def isStarted?
                event_start_time < Time.now && Time.now < event_end_time
            end
            
            def isEnded?
                event_end_time < Time.now && Time.now < closed_at
            end
            
            def isClosed?
                closed_at < Time.now
            end


            def status
                result=""
                result = "Locked"  if isLocked?
                result = "Unlocked"  if isUnLocked?
                result = "Opened" if isOpened?
                result = "Enroling" if isEnroling?
                result = "Started" if isStarted?
                result = "Ended" if isEnded?
                result = "Closed" if isClosed?
                
                result
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