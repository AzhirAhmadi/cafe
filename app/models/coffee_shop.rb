# == Schema Information
#
# Table name: coffee_shops
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  address       :string           not null
#  owner_id      :integer          not null
#  creator_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  maintainer_id :integer          not null
#

class CoffeeShop < ApplicationRecord
    include Generals::SoftDelete

    include Methods::CoffeeShop
    include Scopes::CoffeeShop
    include Validations::CoffeeShop
    
    belongs_to :creator, class_name: "User"
    belongs_to :maintainer, class_name: "User"
    belongs_to :owner, class_name: "User"

    has_many :created_board_games, class_name: "BoardGame", foreign_key: "creator_id"
    has_many :created_events, class_name: "Event", foreign_key: "coffee_shop_id"
end
