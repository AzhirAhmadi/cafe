class MyError::User
    class DataBaseCreation < MyError
        def message
            args[:user].errors
        end
    end
    class UsernameOrPassword < MyError
        def message
            "Username or password are wrong!"
        end
    end
end