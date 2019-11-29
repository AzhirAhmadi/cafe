module ErrorHandling::Errors::Enrolment
    class DataBaseFind < ErrorHandling::Error
        def message
            "Couldn't find enrolment"
        end
    end

    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:enrolment].errors
        end
    end

    class DataBaseUpdate < ErrorHandling::Error
        def message
            args[:enrolment].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for create enrolment must be provided like this:{\"enrolment\" :{\"table_id\" : \"id\"}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update enrolment must be provided like this:{\"enrolment\" :{\"table_id\" : \"id\"}}"
        end
    end

    class DeletedEnrolment < ErrorHandling::Error
        def message
           "This enrolment has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end