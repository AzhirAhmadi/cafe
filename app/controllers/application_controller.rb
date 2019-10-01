# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, unless: :json_request?
    protect_from_forgery with: :null_session, if: :json_request?
    skip_before_action :verify_authenticity_token, if: :json_request?
    rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_auth_token
    before_action :set_current_user, if: :json_request?

    private
    def json_request?
      request.format.json?
    end

    def authenticate_user!(*args)
      super and return unless args.blank?
      json_request? ? authenticate_api_user! : super
    end
    
    def invalid_auth_token
      respond_to do |format|
        format.html { redirect_to sign_in_path, 
                      error: 'Login invalid or expired' }
        format.json { head 401 }
      end
    end
    # So we can use Pundit policies for api_users
    def set_current_user
      @current_user ||= warden.authenticate(scope: :user)
    end
  end