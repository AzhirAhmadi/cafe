# == Schema Information
#
# Table name: tables
#
#  id            :integer          not null, primary key
#  table_code    :string           not null
#  deleted_at    :datetime
#  event_id      :integer
#  board_game_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  capacity      :integer
#  enroled       :integer          default("0")
#
# Indexes
#
#  index_tables_on_board_game_id            (board_game_id)
#  index_tables_on_event_id                 (event_id)
#  index_tables_on_table_code_and_event_id  (table_code,event_id) UNIQUE
#

FactoryBot.define do
  factory :table do
    capacity {5}
    sequence(:table_code) { |n| "code#{n}#{rand(100000..999999).to_s}" }

    transient do
      coffee_shop {create :coffee_shop}
    end
    event {create :event, coffee_shop: coffee_shop}
    board_game {create :board_game, coffee_shop: coffee_shop}
  end

  factory :opened_table, class: Table do
    capacity {5}
    sequence(:table_code) { |n| "code#{n}#{rand(100000..999999).to_s}" }

    transient do
      coffee_shop {create :coffee_shop}
    end
    event {create :opened_event, coffee_shop: coffee_shop}
    board_game {create :board_game, coffee_shop: coffee_shop}
  end

  factory :locked_table, class: Table do
    capacity {5}
    sequence(:table_code) { |n| "code#{n}#{rand(100000..999999).to_s}" }

    transient do
      coffee_shop {create :coffee_shop}
    end
    event {create :locked_event, coffee_shop: coffee_shop}
    board_game {create :board_game, coffee_shop: coffee_shop}
  end
end
