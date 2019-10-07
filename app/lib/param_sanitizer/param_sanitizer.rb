class  ParamSanitizer::ParamSanitizer
    attr_reader :current_user, :params
    def initialize(current_user, params)
        @current_user = current_user
        @params = params
    end

    def create_params
        []
    end

    def update_params
        []
    end

    protected
        def data_is_for_current_user 
            current_user&.id == params[:id]
        end

        def new_role_is_lower_then_current_user_role 
            user_role = params[:user][:role]
            !current_user.blank? && ((User.role_power current_user) > (User.role_power user_role))
        end

        def has_current_user
            current_user.blank?
        end
end