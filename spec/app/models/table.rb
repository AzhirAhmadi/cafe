require 'rails_helper'

RSpec.describe Table, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      expect(create :table).to be_valid
    end

    it "should validate presence of attributes" do
      table = build :table, capacity: nil, table_number: nil, event_id: nil, board_game_id: nil


      expect(table).not_to be_valid
      expect(table.errors.messages[:event]).to include("must exist")
      expect(table.errors.messages[:event]).to include("can't be blank")
      expect(table.errors.messages[:board_game]).to include("must exist")
      expect(table.errors.messages[:board_game]).to include("can't be blank")
      expect(table.errors.messages[:capacity]).to include("can't be blank")
      expect(table.errors.messages[:table_number]).to include("can't be blank")
    end

    it "should validate event activeness" do
      event =create :event

      event.deleted_at = Time.current
      expect(event.active?).to eq(false)

      table = build :table, event: event
      expect(table).not_to be_valid
      expect(table.errors.messages[:event]).to include("is not active")
    end

    it "should validate board_game activeness" do
      board_game =create :board_game

      board_game.deleted_at = Time.current
      expect(board_game.active?).to eq(false)

      table = build :table, board_game: board_game
      expect(table).not_to be_valid
      expect(table.errors.messages[:board_game]).to include("is not active")
    end

    it "should except methods (:event)" do
      table = create :table
      
      expect(table).to respond_to(:event)
    end

    it "should except methods (:board_game)" do
      table = create :table
      
      expect(table).to respond_to(:board_game)
    end
  end
end