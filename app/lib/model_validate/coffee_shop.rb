module ModelValidate::CoffeeShop
    def active_owner
        errors.add(:owner, "is not active") unless  owner&.active?
    end
    
    def active_creator
        errors.add(:creator, "is not active") unless  creator&.active?
    end

    def owner_role
        errors.add(:owner, "role must be 'cafe_owner'") unless  owner&.cafe_owner?
    end 

    def creator_role
        errors.add(:creator, "role must be 'sys_admin'") unless  creator&.sys_admin?
    end 
end