class ApplicationPolicy 
    attr_reader :requesting_user, :data
  
    def initialize(user, data)
      @requesting_user = user
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
end