module ErrorHandling::Errors::User
    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:user].errors
        end
    end
    
    class UsernameOrPassword < ErrorHandling::Error
        def message
            "Username or password are wrong!"
        end
    end

    class DeletedUser < ErrorHandling::Error
        def message
           "Your account has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end