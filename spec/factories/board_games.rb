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

FactoryBot.define do
  factory :board_game do
    name { "MyString" }
    publisher { "MyString" }
    min_player { "MyString" }
    max_player { "MyString" }
    play_time { "MyString" }
    description { "MyText" }
  end
end
