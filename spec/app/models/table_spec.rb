require 'rails_helper'

RSpec.describe Table, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      expect(create :table).to be_valid
    end

    it "should validate presence of attributes" do
      table = build :table, capacity: nil, table_code: nil, event_id: nil, board_game_id: nil


      expect(table).not_to be_valid
      expect(table.errors.messages[:event]).to include("must exist")
      expect(table.errors.messages[:event]).to include("can't be blank")
      expect(table.errors.messages[:board_game]).to include("must exist")
      expect(table.errors.messages[:board_game]).to include("can't be blank")
      expect(table.errors.messages[:capacity]).to include("can't be blank")
      expect(table.errors.messages[:table_code]).to include("can't be blank")
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

    it "should validate board_game owner_ship by coffee_shop which created event" do
      board_game =create :board_game

      table = build :table, board_game: board_game
      expect(table).not_to be_valid
      expect(table.errors.messages[:board_game]).to include("is not owened by this coffe_shop")
    end
    it "should validate  uniqueness of [:table_code, event_id]" do
      coffee_shop =create :coffee_shop

      event = create :event, coffee_shop: coffee_shop
      board_game = create :board_game, coffee_shop: coffee_shop

      table = create :table, event: event, board_game: board_game
      new_table = build :table, table_code: table.table_code, event: event, board_game: board_game

      expect(new_table).not_to be_valid
      expect(new_table.errors.messages[:table_code]).to include("has already been taken")
    end

    it "should except methods (:event)" do
      table = create :table
      
      expect(table).to respond_to(:event)
    end

    it "should except methods (:board_game)" do
      table = create :table
      
      expect(table).to respond_to(:board_game)
    end

    it "should respond_to method enroled_users" do
      table = create :opened_table
      expect(table).to respond_to(:enroled_users)
    end
  end
end