module DeviseHelper
    @token
    def login user
        @request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, params: {"user": {"email": user.email, "password": user.password }}, format: :json
        @token = JSON.parse(response.body)["jwt"]
        response
    end

    def logout
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @request.headers["Authorization"] = token
        delete :destroy, params: {}, format: :json
        @token = nil
    end

    def token
        @token
    end

end