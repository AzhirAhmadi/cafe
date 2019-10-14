# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include Pundit
  prepend ParamSanitizer::Sanitizer

  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  #my filter
  prepend_before_action :check_json_format

  rescue_from StandardError, with: :render_error
  # rescue_from ErrorHandling::Errors, with: :render_error
  
  private
    def json_request?
      request.format.json?
    end

    def authenticate_user!(*args)
      check_authorization_token
      set_current_user
      raise ErrorHandling::Errors::JwtToken::Unauthorized.new  params: params if @current_user.blank? 
    end
    
    def set_current_user
      @current_user ||= User.find_by_jti(decode_authorization_token)
    end

    #my methods
    def check_authorization_token
      if request.headers["Authorization"].blank?
        raise ErrorHandling::Errors::JwtToken::Absence.new  params: params
      end
    end

    def check_json_format
      unless request.format == :json
        sign_out
        raise ErrorHandling::Errors::Requset::NonJsonInput.new  params: params
      end
    end

    def decode_authorization_token
      return nil if request.headers["Authorization"].blank?
      
      token = request.headers["Authorization"].split('Bearer ').last
      secret = ENV['DEVISE_JWT_SECRET_KEY']
      JWT.decode(token, secret, true, algorithm: 'HS256',
        verify_jti: true)[0]['jti']
    rescue JWT::DecodeError
      raise ErrorHandling::Errors::JwtToken::Wrong.new  params: params
    end


    def render_error(exception)
      render json: (ErrorHandling::ErrorRenderer.error_to_JSON exception), status: 500
    end
  end