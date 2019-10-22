module ModelValidate::BoardGame
    def active_creator
        errors.add(:creator, "is not active") unless  creator&.active?
    end
end