require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe ".show" do
        context "when loged in az player" do
            it "shloud see table in open event which is in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json["data"]["id"].to_i).to eql(opened_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud not see table in open event which is not in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table which is not in open event in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_event = create :opened_event
                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_event, opened_table),
                headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table in locked event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                locked_table = create :locked_table
                
                get coffee_shop_event_table_url(locked_table.event.coffee_shop, locked_table.event, locked_table),
                headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see deactivated table" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.deleted_at = Time.now
                opened_table.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table in deactivated event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.deleted_at = Time.now
                opened_table.event.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table in deactivated coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.coffee_shop.deleted_at = Time.now
                opened_table.event.coffee_shop.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end
        end
    end

    describe ".index" do
        context "when loged in az player" do
            it "shloud see table in open event which is in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"][0]["id"].to_i).to eql(opened_table.id)
                expect(json["data"][0]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"][0]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud not see table in open event which is not in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(coffee_shop, opened_table.event),
                headers: headers
                
                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table which is not in open event in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_event = create :opened_event
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_event),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table in locked event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                locked_table = create :locked_table
                
                get coffee_shop_event_tables_url(locked_table.event.coffee_shop, locked_table.event),
                headers: headers
                
                expect(json["data"].length).to eql(0)
            end

            it "shloud not see deactivated table" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.deleted_at = Time.now
                opened_table.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table in deactivated event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.deleted_at = Time.now
                opened_table.event.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table in deactivated coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.coffee_shop.deleted_at = Time.now
                opened_table.event.coffee_shop.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(0)
            end
        end
    end

    describe ".create" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                board_game = create :board_game, coffee_shop: coffee_shop

                count = Table.count
                post coffee_shop_event_tables_url(coffee_shop, opened_event), params: {
                    "table": {
                        "capacity": 99,
                        "table_code": "code_99",
                        "board_game_id": board_game.id
                    }
                }, headers: headers
                newCount = Table.count

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
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                opened_table = create :opened_table

                put coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table), params: {
                    "table": {
                        "capacity": 99,
                        "table_code": "code_99",
                        "board_game_id": opened_table.board_game.id
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

    describe ".deactivate" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                opened_table = create :opened_table

                delete coffee_shop_event_table_deactivate_url(opened_table.event.coffee_shop, opened_table.event, opened_table), params: {
                    "table": {
                        "capacity": 99,
                        "table_code": "code_99",
                        "board_game_id": opened_table.board_game.id
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
end