require 'rails_helper'

RSpec.describe BoardGamesController, type: :request do
    describe "#create" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop =create :coffee_shop
                count = BoardGame.count
                post coffee_shop_board_games_url(coffee_shop), params: {
                    "board_game": {
                        "name": "name",
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
    describe "update" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "name",
                        "address": "address",
                        "owner_id": 1,
                        "maintainer_id": 1
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
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                delete coffee_shop_deactivate_url(coffee_shop), headers: headers
                
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