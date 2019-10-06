module ErrorHandling::Errors::Requset
    class NonJsonInput < ErrorHandling::Error
        def message
            "JSON requests only!"
        end
    end
    class UsernameOrPassword < ErrorHandling::Error
        def message
            "Username or password are wrong!"
        end
    end
end