class MyError::Requset
    class NonJsonInput < MyError
        def message
            "JSON requests only!"
        end
    end
    class UsernameOrPassword < MyError
        def message
            "Username or password are wrong!"
        end
    end
end