module ErrorHandling::Errors::JwtToken
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
end