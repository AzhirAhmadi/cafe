
class  ParamSanitizer::TablesParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :coffee_owner,    :player]
    def create_params
        if current_user.coffee_owner? || current_user.sys_expert? ||
            current_user.sys_admin? || current_user.sys_master?
            return [:capacity, :table_code, :board_game_id]
        end
    end

    def update_params
        if current_user.coffee_owner? || current_user.sys_expert? ||
            current_user.sys_admin? || current_user.sys_master?
            return [:capacity, :table_code, :board_game_id]
        end
    end
end