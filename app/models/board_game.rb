# == Schema Information
#
# Table name: board_games
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  publisher      :string           not null
#  min_player     :integer          not null
#  max_player     :integer          not null
#  play_time      :integer          not null
#  description    :text
#  deleted_at     :datetime
#  coffee_shop_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class BoardGame < ApplicationRecord
    belongs_to :creator, class_name: "CoffeeShop"

    
end
