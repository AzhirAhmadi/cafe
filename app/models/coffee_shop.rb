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
    
    belongs_to :creator, class_name: "User"
    belongs_to :maintainer, class_name: "User"
    belongs_to :owner, class_name: "User"

    has_many :created_board_games, class_name: "BoardGame", foreign_key: "creator_id"
    has_many :created_events, class_name: "Event", foreign_key: "coffee_shop_id"

    validates :name, uniqueness: { case_sensitive: false }
    validates :owner_id, uniqueness: { case_sensitive: false}

    validates :name, :address, :owner_id, :creator_id, presence: true
    
    include ModelValidate::CoffeeShop
    validate :active_owner
    validate :active_maintainer
    validate :active_creator, on: [:create]

    validate :owner_role
    validate :maintainer_role
    validate :creator_role, on: [:create]

    #soft delete config
    def soft_delete  
        update_attribute(:deleted_at, Time.current)  
    end 

    def active?
        !deleted_at?
    end
end
