module ModelValidate::BoardGame
    def active_coffee_shop
        errors.add(:coffee_shop, "is not active") unless  coffee_shop&.active?
    end
end