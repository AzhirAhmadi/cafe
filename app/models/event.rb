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
# Indexes
#
#  index_events_on_coffee_shop_id  (coffee_shop_id)
#

class Event < ApplicationRecord
    include Generals::SoftDelete    

    include Methods::Event
    include Scopes::Event
    include Validations::Event

    belongs_to :coffee_shop, class_name: "CoffeeShop"

    has_many :created_tables, class_name: "Table", foreign_key: "event_id"
    has_one :avatar, :as => :parent, class_name: "Image", dependent: :destroy
end
