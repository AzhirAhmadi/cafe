class ErrorHandling::ErrorRenderer < ActionController::API

    def self.error_to_JSON(exception)
        return error_handling exception if exception.is_a? ErrorHandling::Error
        return pundit exception if exception.is_a? Pundit::Error

        return default exception
    end

    private
        def self.error_handling exception
            json = {}
            json[:message] = exception.message
            unless exception.args[:params].blank?
                controller = exception.args[:params][:controller]
                action = exception.args[:params][:action]
                json[:path] = controller + "#" + action
            end
            return {error: json}
        end

        def self.pundit exception
            json = {}
            json[:text] = "Access denied!"
            json[:class] = exception.class.to_s
            return {error: json}
        end

        def self.default exception
            json = {}
            json[:text] = exception
            json[:class] = exception.class.to_s
            return {error: json}
        end

end