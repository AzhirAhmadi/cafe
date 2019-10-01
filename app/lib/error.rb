module Error
    # JWT teken errors
    class JwtToken
        class Wrong < StandardError;end
        class Absence < StandardError;end
    end
    #Requset errors
    class Requset
        class NonJsonInput < StandardError; end
        class UsernameOrPassword < StandardError; end
    end
end