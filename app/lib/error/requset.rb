class Error::Requset
    class NonJsonInput < Error
        def message
            "JSON requests only!"
        end
    end
    class UsernameOrPassword < Error
        def message
            "Username or password are wrong!"
        end
    end
end