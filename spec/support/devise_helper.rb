module DeviseHelper
    @token

    def login user
        post login_url, params: {"user": {"email": user.email, "password": user.password }}
        @token = JSON.parse(response.body)["jwt"]
        response
    end

    def logout
        headers = {"Authorization": @token}
        delete logout_url, headers: headers
        @token = nil
    end

    def token
        @token
    end

    def authorized_request method, params: nil
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @request.headers["Authorization"] = token

        case method
        when "post"
            post :create, params: params, format: :json
        when "delete"
            delete :destroy, params: params, format: :json
        end
    end

end