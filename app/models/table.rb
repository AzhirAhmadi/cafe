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

class Table < ApplicationRecord
    include Generals::SoftDelete    

    include Methods::Table
    include Scopes::Table
    include Validations::Table

    belongs_to :event, class_name: "Event"
    belongs_to :board_game, class_name: "BoardGame"

    has_many :enrolments
    has_many :enroled_users, through: :enrolments, source: :user
end
