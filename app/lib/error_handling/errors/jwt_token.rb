module ErrorHandling::Errors::JwtToken
    class Wrong < ErrorHandling::Error
        def message
            "Wrong jwt token!"
        end
    end
    class Absence < ErrorHandling::Error
        def message
            "Authorization header needed!"
        end
    end

    class Unauthorized < ErrorHandling::Error
        def message
            "Unauthorized!"
        end
    end
end