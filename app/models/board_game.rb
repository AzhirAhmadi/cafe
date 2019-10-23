# == Schema Information
#
# Table name: board_games
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  publisher   :string           not null
#  min_player  :integer          not null
#  max_player  :integer          not null
#  play_time   :integer          not null
#  description :text
#  deleted_at  :datetime
#  creator_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BoardGame < ApplicationRecord
    belongs_to :creator, class_name: "CoffeeShop"

    validates :name, :publisher, :min_player, :max_player, :play_time, presence: true
    validates :name, uniqueness: { scope: :creator_id}

    include ModelValidate::BoardGame
    validate :active_creator


    #soft delete config
    def soft_delete  
        update_attribute(:deleted_at, Time.current)  
    end 

    def active?
        !deleted_at?
    end
end
