module ErrorHandling::Errors::JwtToken
    class Wrong < ErrorHandling::Error
        def message
            "Not Acceptable!"
        end

        def status
            406 # Not Acceptable
        end
    end
    class Absence < ErrorHandling::Error
        def message
            "Bad Request!"
        end

        def status
            400 # 400 Bad Request
        end
    end

    class Unauthorized < ErrorHandling::Error
        def message
            "Not Acceptable!"
        end

        def status
            401 # 401 Unauthorized
        end
    end
end