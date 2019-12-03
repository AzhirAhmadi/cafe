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

FactoryBot.define do
  factory :board_game do
    sequence(:name) { |n| "BoardGame_Name#{n}#{rand(100000..999999).to_s}" }
    publisher { "MyString" }
    min_player { 2 }
    max_player { 7 }
    play_time { 30 }
    description { "Description Text" }

    association :coffee_shop, factory: :coffee_shop
  end
end
