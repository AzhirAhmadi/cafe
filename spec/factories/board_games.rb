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

FactoryBot.define do
  factory :board_game do
    sequence(:name) { |n| "BoardGame_Name#{n}" }
    publisher { "MyString" }
    min_player { 2 }
    max_player { 7 }
    play_time { 30 }
    description { "Description Text" }

    association :creator, factory: :coffee_shop
  end
end
