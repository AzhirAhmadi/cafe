
class  ParamSanitizer::EventsParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :coffee_owner,    :player]
    def create_params
        if current_user.coffee_owner? || current_user.sys_expert?
            return [:name, :description, :opens_at, :enrol_start_time, :enrol_end_time, :event_start_time, :event_end_time, :closed_at] 
        end
    end

    def update_params
        if current_user.coffee_owner? || current_user.sys_expert?
            return [:name, :description, :opens_at, :enrol_start_time, :enrol_end_time, :event_start_time, :event_end_time, :closed_at] 
        end
    end
end