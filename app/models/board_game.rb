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
    include Generals::SoftDelete

    include Methods::BoardGame
    include Scopes::BoardGame
    include Validations::BoardGame

    belongs_to :creator, class_name: "CoffeeShop"
end
