module ErrorHandling::Errors::CoffeeShop
    class DataBaseFind < ErrorHandling::Error
        def message
            "Couldn't find coffee shop"
        end
    end

    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:coffee_shop].errors
        end
    end

    class DataBaseUpdate < ErrorHandling::Error
        def message
            args[:coffee_shop].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for create coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}"
        end
    end

    class DeletedCoffeeShop < ErrorHandling::Error
        def message
           "This coffee shop has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end