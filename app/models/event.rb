class Event < ApplicationRecord
    belongs_to :coffee_shop, class_name: "CoffeeShop"

    validates :name, :description, :opens_at,
    :enrol_start_time, :enrol_end_time, :event_start_time,
    :event_end_time, :closed_at , :coffee_shop, presence: true


    include ModelValidate::Event

    validate :active_coffee_shop
    validate :time_orders
end
