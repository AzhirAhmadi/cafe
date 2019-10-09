module DeviseHelper
    def sing_in user
        @request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, params: {"user": {"email": user.email, "password": user.password }}, format: :json

        response
    end
end