require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe ".show" do
        context "when loged in az sys_master" do
            it "shloud see table in open event which is in coffee_shop" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json["data"]["id"].to_i).to eql(opened_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud see table in locked event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                locked_table = create :locked_table
                
                get coffee_shop_event_table_url(locked_table.event.coffee_shop, locked_table.event, locked_table),
                headers: headers

                expect(json["data"]["id"].to_i).to eql(locked_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( locked_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( locked_table.board_game.id)
            end

            it "shloud see deactivated table" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.deleted_at = Time.now
                opened_table.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json["data"]["id"].to_i).to eql(opened_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud see table in deactivated event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.deleted_at = Time.now
                opened_table.event.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json["data"]["id"].to_i).to eql(opened_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud see table in deactivated coffee_shop" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.coffee_shop.deleted_at = Time.now
                opened_table.event.coffee_shop.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                headers: headers

                expect(json["data"]["id"].to_i).to eql(opened_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end
            
            it "shloud not see table in open event which is not in coffee_shop" do
                sys_master = create :sys_master
                login sys_master
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
                sys_master = create :sys_master
                login sys_master
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
        end
    end

    describe ".index" do
        context "when loged in az sys_master" do
            it "shloud see table in open event which is in coffee_shop" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers
                expect(json["data"][0]["id"].to_i).to eql(opened_table.id)
                expect(json["data"][0]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"][0]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud see table in locked event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                locked_table = create :locked_table
                
                get coffee_shop_event_tables_url(locked_table.event.coffee_shop, locked_table.event),
                headers: headers

                expect(json["data"].length).to eql(1)
            end

            it "shloud see deactivated table" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.deleted_at = Time.now
                opened_table.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(1)
            end

            it "shloud see table in deactivated event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.deleted_at = Time.now
                opened_table.event.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(1)
            end

            it "shloud see table in deactivated coffee_shop" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_table = create :opened_table
                opened_table.event.coffee_shop.deleted_at = Time.now
                opened_table.event.coffee_shop.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(1)
            end

            it "shloud not see table in open event which is not in coffee_shop" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(coffee_shop, opened_table.event),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table which is not in open event in coffee_shop" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_event = create :opened_event
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_event),
                headers: headers

                expect(json["data"].length).to eql(0)
            end
        end
    end

    describe ".create" do
        context "when loged in az sys_master" do
            it "shloud create table for open event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                count = Table.count
                post coffee_shop_event_tables_url(coffee_shop, opened_event), params: {
                    "table": {
                        "capacity": 99,
                        "table_code": "code_99",
                        "board_game_id": board_game.id
                    }
                }, headers: headers
                newCount = Table.count

                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["table_code"]).to eql("code_99")
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql(board_game.id)
            end

            it "shloud create table for locked event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                locked_event = create :locked_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                count = Table.count
                post coffee_shop_event_tables_url(coffee_shop, locked_event), params: {
                    "table": {
                        "capacity": 99,
                        "table_code": "code_99",
                        "board_game_id": board_game.id
                    }
                }, headers: headers
                newCount = Table.count

                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["table_code"]).to eql("code_99")
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql(locked_event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql(board_game.id)
            end

            it "shloud not create table for started event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                count = Table.count
                post coffee_shop_event_tables_url(coffee_shop, started_event), params: {
                    "table": {
                        "capacity": 99,
                        "table_code": "code_99",
                        "board_game_id": board_game.id
                    }
                }, headers: headers
                newCount = Table.count

                expect(newCount - count).to eq(0)
                expect(json).to include({
                    "error"=>{
                        "message"=>"event is started!"
                    }
                })
            end
        end
    end

    describe ".update" do
         context "when loged in az sys_master" do
            it "shloud update table for open event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                table = create :table, event: opened_event, board_game: board_game

                other_board_game = create :board_game, creator: coffee_shop
                put coffee_shop_event_table_url(coffee_shop, opened_event, table), params: {
                    "table": {
                        "capacity": 10,
                        "table_code": "code",
                        "board_game_id": other_board_game.id
                    }
                }, headers: headers

                expect(json["data"]["attributes"]["table_code"]).to eql("code")
                expect(json["data"]["attributes"]["capacity"]).to eql(10)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql(other_board_game.id)
            end

            it "shloud update table for locked event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                locked_event = create :locked_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                table = create :table, event: locked_event, board_game: board_game

                other_board_game = create :board_game, creator: coffee_shop
                put coffee_shop_event_table_url(coffee_shop, locked_event, table), params: {
                    "table": {
                        "capacity": 10,
                        "table_code": "code",
                        "board_game_id": other_board_game.id
                    }
                }, headers: headers

                expect(json["data"]["attributes"]["table_code"]).to eql("code")
                expect(json["data"]["attributes"]["capacity"]).to eql(10)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql(locked_event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql(other_board_game.id)
            end

            it "shloud not update table for started event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                table = create :table, event: started_event, board_game: board_game

                other_board_game = create :board_game, creator: coffee_shop
                put coffee_shop_event_table_url(coffee_shop, started_event, table), params: {
                    "table": {
                        "capacity": 10,
                        "table_code": "code",
                        "board_game_id": other_board_game.id
                    }
                }, headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"event is started!"
                    }
                })
            end
        end
    end

    describe ".deactivate" do
         context "when loged in az sys_master" do
            it "shloud deactivate table for open event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                table = create :table, event: opened_event, board_game: board_game

                other_board_game = create :board_game, creator: coffee_shop
                delete coffee_shop_event_table_deactivate_url(coffee_shop, opened_event, table), headers: headers

                expect(json["data"]["attributes"]["table_code"]).to eql(table.table_code)
                expect(json["data"]["attributes"]["capacity"]).to eql(table.capacity)
            end

            it "shloud deactivate table for locked event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                locked_event = create :locked_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                table = create :table, event: locked_event, board_game: board_game

                delete coffee_shop_event_table_deactivate_url(coffee_shop, locked_event, table), headers: headers

                expect(json["data"]["attributes"]["table_code"]).to eql(table.table_code)
                expect(json["data"]["attributes"]["capacity"]).to eql(table.capacity)
            end

            it "shloud not deactivate table for started event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                board_game = create :board_game, creator: coffee_shop

                table = create :table, event: started_event, board_game: board_game

                delete coffee_shop_event_table_deactivate_url(coffee_shop, started_event, table), headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"event is started!"
                    }
                })
            end
        end
    end
end