
class  ParamSanitizer::BoardGamesParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :coffee_owner,    :player]
    def create_params
        if current_user.coffee_owner? || current_user.sys_expert? || current_user.sys_admin?
            return [:name, :publisher, :min_player, :max_player, :play_time, :description] 
        end
    end

    def update_params
        if current_user.coffee_owner? || current_user.sys_expert? || current_user.sys_admin?
            return [:name, :publisher, :min_player, :max_player, :play_time, :description] 
        end
    end
end