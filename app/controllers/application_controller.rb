# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception, unless: :json_request?
  # protect_from_forgery with: :null_session, if: :json_request?
  # skip_before_action :verify_authenticity_token, if: :json_request?
  # before_action :set_current_user, if: :json_request?

  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  #my filter
  prepend_before_action :check_json_format
  prepend_before_action :check_authorization_token, if: :json_request?

  #my Errors
  include Rescuers::JwtRescuer
  rescue_from Error::JwtToken::Wrong, with: :jwt_token_wrong
  rescue_from Error::JwtToken::Absence, with: :jwt_token_absence

  include Rescuers::RequsetRescuer
  rescue_from Error::Requset::NonJsonInput, with: :requset_non_json_input
  rescue_from Error::Requset::UsernameOrPassword, with: :username_or_password



  private
    def json_request?
      request.format.json?
    end

    def authenticate_user!(*args)
      super and return unless args.blank?
      json_request? ? authenticate_api_user! : super
    end
    
    # So we can use Pundit policies for api_users
    def set_current_user
      puts ApiUser.find_by_jti(decode_token)
      @current_user ||= User.find_by_jti(decode_token)
      # @current_user ||= warden.authenticate(scope: :api_users)
    end
    
    #my methods
    def check_authorization_token
      if request.headers["Authorization"].blank?
        raise Error::JwtToken::Absence
      end
    end

    def check_json_format
      unless request.format == :json
        sign_out
        raise Error::Requset::NonJsonInput
      end
    end



    def decode_token
      token = request.headers["Authorization"].split('Bearer ').last
      secret = ENV['DEVISE_JWT_SECRET_KEY']
      JWT.decode(token, secret, true, algorithm: 'HS256',
                 verify_jti: true)[0]['jti']
    end
  end