module ErrorHandling::Errors::User

    class DataBaseFind < ErrorHandling::Error
        def message
            "Couldn't find User"
        end
    end

    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:user].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for sign_up must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}"
        end
    end

    class DeletedUser < ErrorHandling::Error
        def message
           "Your account has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end