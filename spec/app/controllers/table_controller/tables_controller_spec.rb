require 'rails_helper'

RSpec.describe TablesController, type: :request do
    describe ".show" do
        context "when no one loged in" do
            it "shloud see table in open event which is in coffee_shop" do
                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table)
                expect(json["data"]["id"].to_i).to eql(opened_table.id)
                expect(json["data"]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud not see table in open event which is not in coffee_shop" do
                coffee_shop = create :coffee_shop
                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(coffee_shop, opened_table.event, opened_table)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table which is not in open event in coffee_shop" do
                opened_event = create :opened_event
                opened_table = create :opened_table
                
                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_event, opened_table)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table in locked event" do
                locked_table = create :locked_table
                
                get coffee_shop_event_table_url(locked_table.event.coffee_shop, locked_table.event, locked_table)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see deactivated table" do
                opened_table = create :opened_table
                opened_table.deleted_at = Time.now
                opened_table.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table in deactivated event" do
                opened_table = create :opened_table
                opened_table.event.deleted_at = Time.now
                opened_table.event.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end

            it "shloud not see table in deactivated coffee_shop" do
                opened_table = create :opened_table
                opened_table.event.coffee_shop.deleted_at = Time.now
                opened_table.event.coffee_shop.save

                get coffee_shop_event_table_url(opened_table.event.coffee_shop, opened_table.event, opened_table)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find table"
                    }
                })
            end
        end
    end

    describe ".index" do
        context "when no one loged in" do
            it "shloud see table in open event which is in coffee_shop" do
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event)
                expect(json["data"][0]["id"].to_i).to eql(opened_table.id)
                expect(json["data"][0]["relationships"]["event"]["data"]["id"].to_i).to eql( opened_table.event.id)
                expect(json["data"][0]["relationships"]["board_game"]["data"]["id"].to_i).to eql( opened_table.board_game.id)
            end

            it "shloud not see table in open event which is not in coffee_shop" do
                coffee_shop = create :coffee_shop
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(coffee_shop, opened_table.event)

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table which is not in open event in coffee_shop" do
                opened_event = create :opened_event
                opened_table = create :opened_table
                
                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_event)

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table in locked event" do
                locked_table = create :locked_table
                
                get coffee_shop_event_tables_url(locked_table.event.coffee_shop, locked_table.event)

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see deactivated table" do
                opened_table = create :opened_table
                opened_table.deleted_at = Time.now
                opened_table.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event)

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table in deactivated event" do
                opened_table = create :opened_table
                opened_table.event.deleted_at = Time.now
                opened_table.event.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event)

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see table in deactivated coffee_shop" do
                opened_table = create :opened_table
                opened_table.event.coffee_shop.deleted_at = Time.now
                opened_table.event.coffee_shop.save

                get coffee_shop_event_tables_url(opened_table.event.coffee_shop, opened_table.event)

                expect(json["data"].length).to eql(0)
            end
        end
    end
    
    describe ".create" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                event = create :event
                post coffee_shop_event_tables_url(coffee_shop,event)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"tables#create"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                event = create :event

                headers = {"Authorization": "invalid"}
                post coffee_shop_event_tables_url(coffee_shop,event),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"tables#create"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of table)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                post coffee_shop_event_tables_url(coffee_shop,event),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for create table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#create"
                    }
                )
            end

            it "(absence of capacity)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                post coffee_shop_event_tables_url(coffee_shop,event),params:{
                    "table":{
                        "test": "test"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for create table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#create"
                    }
                )
            end

            it "(absence of table_code)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                post coffee_shop_event_tables_url(coffee_shop,event),params:{
                    "table":{
                        "capacity": 99
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for create table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#create"
                    }
                )
            end

            it "(absence of board_game_id)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                post coffee_shop_event_tables_url(coffee_shop,event),params:{
                    "table":{
                        "capacity": 99,
                        "table_code": "code_99"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for create table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#create"
                    }
                )
            end
        end
    end

    describe ".update" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                table = create :table
                put coffee_shop_event_table_url(table.event.coffee_shop, table.event, table)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"tables#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                table = create :table

                headers = {"Authorization": "invalid"}
                put coffee_shop_event_table_url(table.event.coffee_shop, table.event, table),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"tables#update"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of table)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                table = create :table
                put coffee_shop_event_table_url(table.event.coffee_shop, table.event, table),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#update"
                    }
                )
            end

            it "(absence of capacity)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                table = create :table
                put coffee_shop_event_table_url(table.event.coffee_shop, table.event, table),params:{
                    "table":{
                        "test": "test"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#update"
                    }
                )
            end

            it "(absence of table_code)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                table = create :table
                put coffee_shop_event_table_url(table.event.coffee_shop, table.event, table),params:{
                    "table":{
                        "capacity": 99
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#update"
                    }
                )
            end

            it "(absence of board_game_id)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                table = create :table
                put coffee_shop_event_table_url(table.event.coffee_shop, table.event, table),params:{
                    "table":{
                        "capacity": 99,
                        "table_code": "code_99"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}",
                        "path"=>"tables#update"
                    }
                )
            end
        end
    end

    describe ".deactivate" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                table = create :table
                delete coffee_shop_event_table_url(table.event.coffee_shop, table.event, table)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"tables#deactivate"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                table = create :table

                headers = {"Authorization": "invalid"}
                delete coffee_shop_event_table_url(table.event.coffee_shop, table.event, table),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"tables#deactivate"
                    }
                )
            end
        end
    end
end