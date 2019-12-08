require 'rails_helper'

RSpec.describe BoardGamesController, type: :request do
    describe ".create" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                post coffee_shop_board_games_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"board_games#create"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                headers = {"Authorization": "invalid"}
                post coffee_shop_board_games_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"board_games#create"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of coffee_shop)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_board_games_url(coffee_shop), params: {

                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#create"
                    }
                )
            end

            it "(absence of name)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {"test": "wewe"}
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#create"
                    }
                )
            end

            it "(absence of publisher)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "name"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#create"
                    }
                )
            end

            it "(absence of min_player)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "name",
                        "publisher": "publisher"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#create"
                    }
                )
            end

            it "(absence of max_player)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "name",
                        "publisher": "publisher",
                        "min_player": 1
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#create"
                    }
                )
            end

            it "(absence of paly_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "name",
                        "publisher": "publisher",
                        "min_player": 1,
                        "max_player": 3
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#create"
                    }
                )
            end
        end
    end

    describe ".update" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"board_games#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                headers = {"Authorization": "invalid"}
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"board_games#update"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of coffee_shop)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {

                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#update"
                    }
                )
            end

            it "(absence of name)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {"test": "wewe"}
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#update"
                    }
                )
            end

            it "(absence of publisher)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {
                        "name": "name"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#update"
                    }
                )
            end

            it "(absence of min_player)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {
                        "name": "name",
                        "publisher": "publisher"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#update"
                    }
                )
            end

            it "(absence of max_player)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {
                        "name": "name",
                        "publisher": "publisher",
                        "min_player": 1
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#update"
                    }
                )
            end

            it "(absence of paly_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                board_game = create :board_game
                put coffee_shop_board_game_url(coffee_shop, board_game), params: {
                    "board_game": {
                        "name": "name",
                        "publisher": "publisher",
                        "min_player": 1,
                        "max_player": 3
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}",
                        "path"=>"board_games#update"
                    }
                )
            end
        end
    end

    describe ".destroy" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                board_game = create :board_game
                delete coffee_shop_board_game_url(coffee_shop, board_game)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"board_games#destroy"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                headers = {"Authorization": "invalid"}
                board_game = create :board_game
                delete coffee_shop_board_game_url(coffee_shop, board_game),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"board_games#destroy"
                    }
                )
            end
        end
    end
end