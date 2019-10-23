class Event < ApplicationRecord
    belongs_to :coffee_shop, class_name: "CoffeeShop"
end
