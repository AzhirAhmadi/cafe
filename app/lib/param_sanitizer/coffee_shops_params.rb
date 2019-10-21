
class ParamSanitizer::CoffeeShopsParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :coffee_owner,    :player]
    def create_params
        if current_user.sys_admin? || current_user.sys_master?
            return [:name, :address, :owner_id, :creator_id, :maintainer_id]
        end
    end

    def update_params
        if current_user.sys_admin? || current_user.sys_master?
            return [:name, :address, :owner_id, :maintainer_id] 
        end
        [:name, :address]
    end
end