require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe "#create" do
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
                        "message"=>"Authorization header needed!", 
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
                        "message"=>"Wrong jwt token!" ,
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

    describe "#update" do
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
                        "message"=>"Authorization header needed!", 
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
                        "message"=>"Wrong jwt token!" ,
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

    describe "deactivate" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                coffee_shop = create :coffee_shop
                event = create :event
                delete coffee_shop_event_deactivate_url(coffee_shop, event)

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
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
                        "message"=>"Wrong jwt token!" ,
                        "path"=>"events#deactivate"
                    }
                )
            end
        end
    end
end