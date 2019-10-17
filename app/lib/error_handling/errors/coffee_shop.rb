module ErrorHandling::Errors::CoffeeShop
    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:user].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for create coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\"}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\"}}"
        end
    end

    class DeletedUser < ErrorHandling::Error
        def message
           "Your account has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end