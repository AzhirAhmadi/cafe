# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  description      :string           not null
#  deleted_at       :datetime
#  coffee_shop_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  opens_at         :datetime         not null
#  enrol_start_time :datetime         not null
#  enrol_end_time   :datetime         not null
#  event_start_time :datetime         not null
#  event_end_time   :datetime         not null
#  closed_at        :datetime         not null
#

class Event < ApplicationRecord
    include Generals::SoftDelete    

    include Methods::Event
    include Scopes::Event
    include Validations::Event


    belongs_to :coffee_shop, class_name: "CoffeeShop"

    validates :name, :description, :opens_at,
    :enrol_start_time, :enrol_end_time, :event_start_time,
    :event_end_time, :closed_at , :coffee_shop, presence: true


    include ModelValidate::Event

    validate :active_coffee_shop
    validate :time_orders


end
