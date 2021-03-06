require 'rails_helper'

RSpec.describe BoardGamesController, type: :request do
    describe ".show" do
        context "when loged in az coffee_owner" do
            it "shloud see boardgame in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_game = create :board_game, coffee_shop: coffee_shop
                
                get coffee_shop_board_game_url(coffee_shop, board_game), headers: headers

                expect(json["data"]["id"].to_i).to eql(board_game.id)
            end

            it "shloud not see boardgame which is not in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_game = create :board_game
                
                get coffee_shop_board_game_url(coffee_shop, board_game), headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find board_game"
                    }
                })
            end

            it "shloud not see deactivated boardgame" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_game = create :board_game, coffee_shop: coffee_shop
                
                get coffee_shop_board_game_url(coffee_shop, board_game), headers: headers
                expect(json["data"]["id"].to_i).to eql(board_game.id)

                board_game.deleted_at = Time.now
                board_game.save

                get coffee_shop_board_game_url(coffee_shop, board_game), headers: headers
                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find board_game"
                    }
                })
            end
        end
    end

    describe ".index" do
        context "when loged in az coffee_owner" do
            it "shloud see all boardgames in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_games = create_list :board_game, 10, coffee_shop: coffee_shop
                
                get coffee_shop_board_games_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(10)
            end

            it "shloud not see boardgame which is not in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_games = create_list :board_game, 10, coffee_shop: coffee_shop
                other_board_games = create_list :board_game, 10
                
                get coffee_shop_board_games_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(10)
            end

            it "shloud not see deactivated boardgame" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_games = create_list :board_game, 10, coffee_shop: coffee_shop
                
                get coffee_shop_board_games_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(10)
                
                for i in 0..3 do
                    board_games[i].deleted_at = Time.now
                    board_games[i].save
                end

                get coffee_shop_board_games_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(6)
            end
        end
    end

    describe ".create" do
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
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eq(coffee_shop.id)
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

    describe ".update" do
        context "when loged in az coffee_owner" do
            it "shloud update board_game if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop, owner: coffee_owner 
                board_game = create :board_game, coffee_shop: coffee_shop

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
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end

            it "shloud not create board_game if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                board_game = create :board_game, coffee_shop: coffee_shop

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

    describe ".destroy" do
        context "when loged in az coffee_owner" do
            it "shloud deactivate board_game if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner
                board_game =create :board_game, coffee_shop: coffee_shop

                delete coffee_shop_board_game_url(coffee_shop, board_game), headers: headers

                expect(BoardGame.find(board_game.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(board_game.id) 
            end

            it "shloud not deactivate board_game if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                board_game =create :board_game, coffee_shop: coffee_shop

                delete coffee_shop_board_game_url(coffee_shop, board_game), headers: headers

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