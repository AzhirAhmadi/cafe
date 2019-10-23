module ErrorHandling::Errors::Event
    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:event].errors
        end
    end

    class DataBaseUpdate < ErrorHandling::Error
        def message
            args[:event].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}"
        end
    end

    class DeletedCoffeeShop < ErrorHandling::Error
        def message
           "This event has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end