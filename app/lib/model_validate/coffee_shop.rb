module ModelValidate::CoffeeShop
    def active_owner
        errors.add(:owner, "is not active") unless  owner&.active?
    end

    def active_maintainer
        errors.add(:maintainer, "is not active") unless  maintainer&.active?
    end

    def active_creator
        errors.add(:creator, "is not active") unless  creator&.active?
    end

    def owner_role
        errors.add(:owner, "role must be 'coffee_owner'") unless  owner&.coffee_owner?
    end 

    def maintainer_role
        errors.add(:maintainer, "role must be 'sys_expert'") unless  maintainer&.sys_expert?
    end 

    def creator_role
        errors.add(:creator, "role must be 'sys_admin'") unless  creator&.sys_admin? || creator&.sys_master?
    end 
end