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
# Indexes
#
#  index_coffee_shops_on_creator_id     (creator_id)
#  index_coffee_shops_on_maintainer_id  (maintainer_id)
#  index_coffee_shops_on_owner_id       (owner_id)
#

class CoffeeShop < ApplicationRecord
    include Generals::SoftDelete

    include Methods::CoffeeShop
    include Scopes::CoffeeShop
    include Validations::CoffeeShop
    
    belongs_to :creator, class_name: 'User'
    belongs_to :maintainer, class_name: 'User'
    belongs_to :owner, class_name: 'User'

    has_many :created_board_games, class_name: 'BoardGame', foreign_key: 'coffee_shop_id'
    has_many :created_events, class_name: 'Event', foreign_key: 'coffee_shop_id'
    has_one :avatar, as: :parent, class_name: 'Image', dependent: :destroy
end
