# == Schema Information
#
# Table name: coffee_shops
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string           not null
#  owner_id   :integer          not null
#  creator_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CoffeeShop < ApplicationRecord
    
    belongs_to :creator, class_name: "User"
    belongs_to :owner, class_name: "User"

    validates :name, uniqueness: { case_sensitive: false }
    validates :owner_id, uniqueness: { case_sensitive: false}

    validates :name, :address, :owner_id, :creator_id, presence: true
    
    include ModelValidate::CoffeeShop
    validate :active_owner
    validate :active_creator, on: [:create]

    validate :owner_role
    validate :creator_role, on: [:create]
end
