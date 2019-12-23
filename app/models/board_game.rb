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
#  coffee_shop_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_board_games_on_coffee_shop_id           (coffee_shop_id)
#  index_board_games_on_name_and_coffee_shop_id  (name,coffee_shop_id) UNIQUE
#

class BoardGame < ApplicationRecord
    include Generals::SoftDelete

    include Methods::BoardGame
    include Scopes::BoardGame
    include Validations::BoardGame

    belongs_to :coffee_shop, class_name: "CoffeeShop"

    has_many :created_tables, class_name: "Table", foreign_key: "board_game_id"
    has_one :avatar, :as => :parent, class_name: "Image", dependent: :destroy
end
