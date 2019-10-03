class MyError::JwtToken
    class Wrong < MyError
        def message
            "Wrong jwt token!"
        end
    end
    class Absence < MyError
        def message
            "Authorization header needed!"
        end
    end

    class Unauthorized < MyError
        def message
            "Unauthorized!"
        end
    end
end