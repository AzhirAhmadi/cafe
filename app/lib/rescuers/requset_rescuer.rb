module Rescuers::RequsetRescuer
    def requset_non_json_input
        render json:{
            message: "JSON requests only!"
        }
    end

    def username_or_password
        render json:{
            message: "Username or password are wrong!"
        }
    end
end