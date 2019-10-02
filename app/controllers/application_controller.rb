# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  #my filter
  prepend_before_action :check_json_format
  prepend_before_action :check_authorization_token, if: :json_request?

  rescue_from StandardError, with: :render_error




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
      @current_user ||= User.find_by_jti(decode_token)
    end
    
    #my methods
    def check_authorization_token
      if request.headers["Authorization"].blank?
        raise Error::JwtToken::Absence.new  params: params
      end
    end

    def check_json_format
      unless request.format == :json
        sign_out
        raise Error::Requset::NonJsonInput.new  params: params
      end
    end

    def decode_token
      token = request.headers["Authorization"].split('Bearer ').last
      secret = ENV['DEVISE_JWT_SECRET_KEY']
      JWT.decode(token, secret, true, algorithm: 'HS256',
        verify_jti: true)[0]['jti']
    rescue JWT::DecodeError
      raise Error::JwtToken::Wrong.new  params: params
    end



    def render_error(exception)
      if exception.is_a? Error
        x = {}
        x[:message] = exception.message
        unless exception.args[:params].blank?
          x[:path] = exception.args[:params][:controller] + "#" + exception.args[:params][:action] 
        end
        render json: {error: x}, status: 500
        return
      end
      render json: {
        error: {
          text:exception,
          class: exception.class.to_s
        }
      },
      status: 500
    end
  end