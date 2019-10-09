module ErrorHandling::Errors::Login
    class InvalidParams < ErrorHandling::Error
        def message
            "params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}"
        end
    end
end