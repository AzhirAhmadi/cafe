require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe ".show" do
        context "when no one loged" do
            it "shloud see event in coffee_shop if event is open" do
                coffee_shop = create :coffee_shop

                locked_event = create :locked_event, coffee_shop: coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop

                
                get coffee_shop_event_url(coffee_shop, opened_event)
                expect(json["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)

                get coffee_shop_event_url(coffee_shop, locked_event)
                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find event"
                    }
                })
            end

            it "shloud not see event which is not in coffee_shop" do
                coffee_shop = create :coffee_shop
                event = create :event
                
                get coffee_shop_event_url(coffee_shop, event)

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find event"
                    }
                })
            end

            it "shloud not see deactivated event" do
                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                
                get coffee_shop_event_url(coffee_shop, opened_event)
                expect(json["data"]["id"].to_i).to eql(opened_event.id)

                opened_event.deleted_at = Time.now
                opened_event.save

                get coffee_shop_event_url(coffee_shop, opened_event)
                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find event"
                    }
                })
            end
        end
    end

    describe ".index" do
        context "when no one loged" do
            it "shloud see all opend events in coffee_shop" do
                coffee_shop = create :coffee_shop

                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop
                
                get coffee_shop_events_url(coffee_shop)
                expect(json["data"].length).to eql(5)
            end

            it "shloud not see event which is not in coffee_shop" do
                coffee_shop = create :coffee_shop

                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop

                started_event = create :started_event
                ended_event = create :ended_event
                closed_event = create :closed_event
                
                get coffee_shop_events_url(coffee_shop)
                expect(json["data"].length).to eql(2)
            end

            it "shloud not see deactivated event" do
                coffee_shop = create :coffee_shop
                opened_events = create_list :opened_event, 10, coffee_shop: coffee_shop
                
                get coffee_shop_events_url(coffee_shop)
                expect(json["data"].length).to eql(10)
                
                for i in 0..3 do
                    opened_events[i].deleted_at = Time.now
                    opened_events[i].save
                end

                get coffee_shop_events_url(coffee_shop)
                expect(json["data"].length).to eql(6)
            end
        end
    end
   
    describe ".create" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                post coffee_shop_events_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"events#create"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                headers = {"Authorization": "invalid"}
                post coffee_shop_events_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"events#create"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of event)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {

                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of name)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {"test": "wewe"}
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of description)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {"name": "event_name"}
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of opens_at)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of enrol_start_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of enrol_end_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of event_start_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of event_end_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime",
                        "event_start_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end

            it "(absence of closed_at)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop

                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime",
                        "event_start_time": "datetime",
                        "event_end_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#create"
                    }
                )
            end
        end
    end

    describe ".update" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                event = create :event

                put coffee_shop_event_url(coffee_shop, event), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"events#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                headers = {"Authorization": "invalid"}
                event = create :event

                put coffee_shop_event_url(coffee_shop, event), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                },headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"events#update"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of event)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {

                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of name)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {"test": "wewe"}
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of description)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {"name": "event_name"}
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of opens_at)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of enrol_start_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of enrol_end_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of event_start_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of event_end_time)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime",
                        "event_start_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end

            it "(absence of closed_at)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop =create :coffee_shop
                event = create :event
                put coffee_shop_event_url(coffee_shop,event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime",
                        "event_start_time": "datetime",
                        "event_end_time": "datetime"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update event must be provided like this:{\"event\" :{\"name\" : \"event_name\", \"description\":\"event_description\", \"opens_at\": \"date_time\",  \"enrol_start_time\": \"date_time\",  \"enrol_end_time\": \"date_time\",  \"event_start_time\": \"date_time\",  \"event_end_time\": \"date_time\",  \"closed_at\": \"date_time\",}}",
                        "path"=>"events#update"
                    }
                )
            end
        end
    end

    describe ".deactivate" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                event = create :event
                delete coffee_shop_event_deactivate_url(coffee_shop, event)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"events#deactivate"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                coffee_shop = create :coffee_shop
                headers = {"Authorization": "invalid"}
                event = create :event
                delete coffee_shop_event_deactivate_url(coffee_shop, event),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"events#deactivate"
                    }
                )
            end
        end
    end
end