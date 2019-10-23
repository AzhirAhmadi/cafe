
class  ParamSanitizer::BoardGamesParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :coffee_owner,    :player]
    def create_params
        return [:name, :publisher, :min_player, :max_player, :play_time, :description] if current_user.coffee_owner?
        return [:name, :publisher, :min_player, :max_player, :play_time, :description] if current_user.sys_expert?
    end

    def update_params
        return [:name, :publisher, :min_player, :max_player, :play_time, :description] if current_user.coffee_owner?
        return [:name, :publisher, :min_player, :max_player, :play_time, :description] if current_user.sys_expert?
    end
end