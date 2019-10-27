class ApplicationPolicy 
    attr_reader :current_user,:data
    
    def initialize(current_user, data)
      @current_user = current_user
      @data = data
    end

    def create?
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

    def deactivate?
        false
    end

    class Scope
        attr_reader :current_user, :scope

        def initialize(user, scope)
            @current_user  = user
            @scope = scope
        end

        def resolve
            scope.all
        end
    end
    protected
        def current_user
            @current_user
        end

        def data_is_for_current_user 
            current_user&.id == data.id
        end

        def data_is_lower_then_current_user 
            !current_user.blank? && (User.role_power current_user) > (User.role_power data)
        end

        def has_current_user
            !current_user.blank?
        end
end