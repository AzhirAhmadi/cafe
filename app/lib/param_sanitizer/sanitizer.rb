module ParamSanitizer::Sanitizer
    def sanitize_params
        instance = get_param_sanitizer.new set_current_user, params
        get_permited_prams instance
    end
    private
        def get_param_sanitizer
            controller_name = params[:controller]
            capitalized_controller_name = ""
            controller_name.split('_').each do |item|
                capitalized_controller_name += item.capitalize
            end
            param_sanitizer = ("ParamSanitizer::"+capitalized_controller_name+"Params").constantize
        end

        def get_permited_prams instance
            instance.send(params[:action]+"_params")
        end
end