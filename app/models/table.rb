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

class Table < ApplicationRecord
    include Generals::SoftDelete    

    include Methods::Table
    include Scopes::Table
    include Validations::Table

    belongs_to :event, class_name: "Event"
    belongs_to :board_game, class_name: "BoardGame"
end
