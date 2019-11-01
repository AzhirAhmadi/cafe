require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe ".show" do
        context "when loged in az player" do
            it "shloud see open events in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                opened_event = create :opened_event, coffee_shop: coffee_shop

                get coffee_shop_event_url(coffee_shop, opened_event), headers: headers
                expect(json["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)
            end

            it "shloud not see locked event in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                locked_event = create :locked_event, coffee_shop: coffee_shop

                get coffee_shop_event_url(coffee_shop, locked_event), headers: headers
                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find event"
                    }
                })
            end

            it "shloud not see event which is not in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                event = create :event
                
                get coffee_shop_event_url(coffee_shop, event), headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find event"
                    }
                })
            end

            it "shloud not see deactivated event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                opened_event.deleted_at = Time.now
                opened_event.save

                get coffee_shop_event_url(coffee_shop, opened_event), headers: headers
                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find event"
                    }
                })
            end
        end
    end

    describe ".index" do
        context "when loged in az player" do
            it "shloud see all opend events in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop
                
                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(5)
            end

            it "shloud not see locked events in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop

                locked_event = create :locked_event , coffee_shop: coffee_shop
                
                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(5)
            end

            it "shloud not see event which is not in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop

                started_event = create :started_event
                ended_event = create :ended_event
                closed_event = create :closed_event
                
                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(2)
            end

            it "shloud not see deactivated event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_events = create_list :opened_event, 10, coffee_shop: coffee_shop
                
                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(10)
                
                for i in 0..3 do
                    opened_events[i].deleted_at = Time.now
                    opened_events[i].save
                end

                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(6)
            end
        end
    end

    describe ".create" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop =create :coffee_shop
                count = Event.count
                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime",
                        "event_start_time": "datetime",
                        "event_end_time": "datetime",
                        "closed_at": "datetime"
                    }
                }, headers: headers
                newCount = Event.count

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

                coffee_shop = create :coffee_shop
                event = create :event, coffee_shop: coffee_shop

                put coffee_shop_event_url(coffee_shop, event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": "datetime",
                        "enrol_start_time": "datetime",
                        "enrol_end_time": "datetime",
                        "event_start_time": "datetime",
                        "event_end_time": "datetime",
                        "closed_at": "datetime"
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

                coffee_shop = create :coffee_shop
                event = create :event, coffee_shop: coffee_shop

                delete coffee_shop_event_deactivate_url(coffee_shop, event), headers: headers
                
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