require 'rails_helper'

RSpec.describe BoardGame, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      expect(create :board_game).to be_valid
    end

    it "should validate presence of attributes" do
        board_game = build :board_game, name: nil, publisher: nil, min_player: nil, max_player: nil, play_time: nil
        expect(board_game).not_to be_valid
        
        expect(board_game.errors.messages[:name]).to include("can't be blank")
        expect(board_game.errors.messages[:publisher]).to include("can't be blank")
        expect(board_game.errors.messages[:min_player]).to include("can't be blank")
        expect(board_game.errors.messages[:max_player]).to include("can't be blank")
        expect(board_game.errors.messages[:play_time]).to include("can't be blank")
    end

    it "should validate  uniqueness of [:name, creator_id]" do
      coffee_shop = create :coffee_shop
      board_game1 = create :board_game, name: "Name", creator: coffee_shop
      board_game2 = build :board_game, name: "Name", creator: coffee_shop

      expect(board_game2).not_to be_valid
      expect(board_game2.errors.messages[:name]).to include("has already been taken")

      coffee_shop2 = create :coffee_shop
      board_game3 = create :board_game, name: "Name", creator: coffee_shop2

      expect(board_game3).to be_valid
    end

    it "should validate creator activeness when create" do
      creator =create :coffee_shop

      creator.deleted_at = Time.current
      expect(creator.active?).to eq(false)

      board_game = build :board_game, creator: creator
      expect(board_game).not_to be_valid
      expect(board_game.errors.messages[:creator]).to include("is not active")
    end


    it "should validate creator activeness when update" do
      creator = create :coffee_shop
      board_game = create :board_game, creator: creator
      expect(board_game).to be_valid

      creator.deleted_at = Time.current
      expect(creator.active?).to eq(false)

      board_game.update(name: "newName")
      
      expect(board_game).not_to be_valid
      expect(board_game.errors.messages[:creator]).to include("is not active")
    end

    it "should except methods (:owner, :creator)" do
      board_game = create :board_game
      
      expect(board_game).to respond_to(:creator)
    end
  end
end