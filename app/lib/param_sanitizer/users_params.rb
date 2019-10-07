class ParamSanitizer::UsersParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :cafe_owner,    :player]
    def update_params
        return [:email, :password, :role] if new_role_is_lower_then_current_user_role
        return [:email, :password]
    end

    def create_params
        return [:email, :password, :role] if new_role_is_lower_then_current_user_role
        return [:email, :password]
    end
end