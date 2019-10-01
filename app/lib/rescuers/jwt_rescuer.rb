module Rescuers::JwtRescuer
    def jwt_token_wrong
        render json:{
            message: "Wrong jwt token!"
        }
    end

    def jwt_token_absence
        render json:{
            message: "Authorization header needed!"
        }
    end
end