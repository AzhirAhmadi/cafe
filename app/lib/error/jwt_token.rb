class Error::JwtToken
    class Wrong < Error
        def message
            "Wrong jwt token!"
        end
    end
    class Absence < Error
        def message
            "Authorization header needed!"
        end
    end

    class Unauthorized < Error
        def message
            "Unauthorized!"
        end
    end
end