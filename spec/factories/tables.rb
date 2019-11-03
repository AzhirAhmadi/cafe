# == Schema Information
#
# Table name: tables
#
#  id            :integer          not null, primary key
#  capacity      :string           not null
#  table_number  :string           not null
#  deleted_at    :datetime
#  event_id      :integer
#  board_game_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_tables_on_board_game_id  (board_game_id)
#  index_tables_on_event_id       (event_id)
#

FactoryBot.define do
  factory :table do
    capacity { 5 }
    table_number { 1 }

    association :event, factory: :event
    association :board_game, factory: :board_game
  end
end
