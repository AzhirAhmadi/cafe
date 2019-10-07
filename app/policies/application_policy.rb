class ApplicationPolicy 
    attr_reader :data
    
    @current_user

    def initialize(current_user, data)
      @current_user = current_user
      @data = data
    end

    def craete?
        false
    end

    def show?
        false
    end

    def index?
        false
    end
    def update?
        false
    end

    def destroy?
        false
    end

    protected
        def current_user
            @current_user
        end

        def data_is_for_current_user 
            current_user&.id == data.id
        end

        def data_is_lower_then_current_user 
            (User.role_power current_user) > (User.role_power data)
        end

        def has_current_user
            current_user.blank?
        end
end