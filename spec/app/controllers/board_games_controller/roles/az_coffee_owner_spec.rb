require 'rails_helper'

RSpec.describe BoardGamesController, type: :request do
    describe "#create" do
        context "when loged in az coffee_owner" do
            it "shloud create board_game if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop, owner: coffee_owner 

                count = BoardGame.count
                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "board_game_name",
                        "publisher": "publisher",
                        "min_player": 1,
                        "max_player": 3,
                        "play_time": 20
                    }
                }, headers: headers
                
                newCount = BoardGame.count
                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["name"]).to eq("board_game_name")
                expect(json["data"]["relationships"]["creator"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end

            it "shloud not create board_game if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop

                count = BoardGame.count
                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "board_game_name",
                        "publisher": "publisher",
                        "min_player": 1,
                        "max_player": 3,
                        "play_time": 20
                    }
                }, headers: headers
                
                newCount = BoardGame.count
                expect(newCount - count).to eq(0)
                expect(json["error"]).to include(
                    {
                        "class" => "Pundit::NotAuthorizedError",
                        "text" => "Access denied!"
                    }
                )
            end
        end
    end
    describe "#update" do
        context "when loged in az player" do
            it "shloud update board_game if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop, owner: coffee_owner 
                board_game = create :board_game, creator: coffee_shop

                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {
                        "name": "board_game_name",
                        "publisher": "publisher",
                        "min_player": 1,
                        "max_player": 3,
                        "play_time": 20
                    }
                }, headers: headers

                expect(json["data"]["attributes"]["name"]).to eq("board_game_name")
                expect(json["data"]["relationships"]["creator"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end

            it "shloud not create board_game if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                board_game = create :board_game, creator: coffee_shop

                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {
                        "name": "board_game_name",
                        "publisher": "publisher",
                        "min_player": 1,
                        "max_player": 3,
                        "play_time": 20
                    }
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "class" => "Pundit::NotAuthorizedError",
                        "text" => "Access denied!"
                    }
                )
            end
        end
    end

    describe "deactivate" do
        context "when loged in az player" do
            it "shloud deactivate board_game if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner
                board_game =create :board_game, creator: coffee_shop

                delete coffee_shop_board_game_deactivate_url(coffee_shop, board_game), headers: headers

                expect(BoardGame.find(board_game.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(board_game.id) 
            end

            it "shloud not deactivate board_game if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_game =create :board_game, creator: coffee_shop

                delete coffee_shop_board_game_deactivate_url(coffee_shop, board_game), headers: headers

                expect(BoardGame.find(board_game.id).active?).to eq(true)
                
                expect(json["error"]).to include(
                    {
                        "class" => "Pundit::NotAuthorizedError",
                        "text" => "Access denied!"
                    }
                )
            end
        end
    end
end