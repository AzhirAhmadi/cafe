# app/controllers/api/sessions_controller.rb
class DeviseApi::SessionsController < Devise::SessionsController
    skip_before_action :verify_signed_out_user
    respond_to :json
    # POST /api/login
    def create
      puts "!!!!!!!!!!!!!!!!!!!!!!"
      unless request.format == :json
        sign_out
        render status: 406, 
                 json: { message: "JSON requests only." } and return
      end

      resource = warden.authenticate(scope: :user)
      if resource.blank?
        render status: 401, 
                 json: { response: "Username or password are wrong!" } and return
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
      if request.headers["Authorization"].blank?
        render json: {error: "Authorization param needed!"}
        return
      end
      user = ApiUser.find_by_jti(decode_token)
      if user.blank?
        render json: {message: "wrong Authorization tkoen!"}
        return
      end
      revoke_token(user)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      render json: {
        message: "signed out!"
      }
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

    def decode_token
      token = request.headers["Authorization"].split('Bearer ').last
      secret = ENV['DEVISE_JWT_SECRET_KEY']
      JWT.decode(token, secret, true, algorithm: 'HS256',
                 verify_jti: true)[0]['jti']
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