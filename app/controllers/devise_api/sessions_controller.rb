# app/controllers/api/sessions_controller.rb
class DeviseApi::SessionsController < Devise::SessionsController
    skip_before_action :verify_signed_out_user
    skip_before_action :authenticate_user!, only: [:create]

    respond_to :json
    # POST /api/login
    def create
      if params[:user].blank? || params[:user][:email].blank? || params[:user][:password].blank?
        raise ErrorHandling::Errors::Login::InvalidParams.new  params: params
      end

      resource = warden.authenticate(scope: :user)
      
      if resource.blank?
        raise ErrorHandling::Errors::Requset::UsernameOrPassword.new  params: params
      end
      sign_in(resource_name, resource)
      render json:  {
        success: true,
        email: current_user.email,
        jwt: 'Bearer '+current_token,
        response: "Authentication successful"
      }
    end

    # DELETE /api/logout.json
    def destroy
      user = ApiUser.find_by_jti(decode_authorization_token)
      raise ErrorHandling::Errors::JwtToken::Wrong.new  params: params if user.blank?
      
      revoke_token(user)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      render json: {
        message: "signed out!"
      }
    end

    def self.getCurrentUser
      user = ApiUser.find_by_jti(decode_authorization_token)

      raise ErrorHandling::Errors::JwtToken::Wrong.new  params: params if user.blank?

      user
    end
  private
    def require_no_authentication
      assert_is_devise_resource!
      return unless is_navigational_format?
      no_input = devise_mapping.no_input_strategies

      authenticated = if no_input.present?
        args = no_input.dup.push scope: resource_name
        warden.authenticate?(*args)
      else
        warden.authenticated?(resource_name)
      end
      if authenticated && resource = warden.user(resource_name)
        render json: {message: "Athenticated!",
                      email:current_user.email,
                      jwt: 'Bearer '+current_token}
      end
    end

    def revoke_token(user)
      user.update_column(:jti, generate_jti)
    end

    def current_token
      request.env['warden-jwt_auth.token']
    end

    def generate_jti
      SecureRandom.uuid
    end
end