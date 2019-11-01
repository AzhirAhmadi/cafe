require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe ".show" do
        context "when loged in az coffee_owner" do
            it "shloud see open event in all coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                
                get coffee_shop_event_url(coffee_shop, opened_event), headers: headers
                expect(json["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)
            end

            it "shloud see locked event in coffee_shop if coffee_owner is the owner of coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner
                locked_event = create :locked_event, coffee_shop: coffee_shop

                get coffee_shop_event_url(coffee_shop, locked_event), headers: headers
                expect(json["data"]["id"].to_i).to eql(locked_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)
            end

            it "shloud not see locked event in coffee_shop if coffee_owner is not the owner of coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
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
                coffee_owner = create :coffee_owner
                login coffee_owner
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
                coffee_owner = create :coffee_owner
                login coffee_owner
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
        context "when loged in az coffee_owner" do

            it "shloud see all opend events in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                # 6 event
                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop
                
                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(5)
            end

            it "shloud see locked event in coffee_shop if coffee_owner is the owner of coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner
                # 5 event
                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop

                locked_event = create :locked_event, coffee_shop: coffee_shop

                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(6)
            end

            it "shloud not see locked event in coffee_shop if coffee_owner is not the owner of coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                # 6 event
                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop

                locked_event = create :locked_event, coffee_shop: coffee_shop

                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(5)
            end

            it "shloud not see event which is not in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
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

            it "shloud not see deactivated event in coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
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
        context "when loged in az coffee_owner" do
            it "shloud create event if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop, owner: coffee_owner 

                count = Event.count
                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": Time.now + 1.hours,
                        "enrol_start_time": Time.now + 2.hours,
                        "enrol_end_time": Time.now + 3.hours,
                        "event_start_time": Time.now + 4.hours,
                        "event_end_time": Time.now + 5.hours,
                        "closed_at": Time.now + 6.hours
                    }
                }, headers: headers

                newCount = Event.count
                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["name"]).to eq("event_name")
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end

            it "shloud not create event if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop

                count = Event.count
                post coffee_shop_events_url(coffee_shop), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": Time.now + 1.hours,
                        "enrol_start_time": Time.now + 2.hours,
                        "enrol_end_time": Time.now + 3.hours,
                        "event_start_time": Time.now + 4.hours,
                        "event_end_time": Time.now + 5.hours,
                        "closed_at": Time.now + 6.hours
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
        context "when loged in az coffee_owner" do
            it "shloud update event if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop, owner: coffee_owner 
                event = create :event, coffee_shop: coffee_shop

                put coffee_shop_event_url(coffee_shop, event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": Time.now + 1.hours,
                        "enrol_start_time": Time.now + 2.hours,
                        "enrol_end_time": Time.now + 3.hours,
                        "event_start_time": Time.now + 4.hours,
                        "event_end_time": Time.now + 5.hours,
                        "closed_at": Time.now + 6.hours
                    }
                }, headers: headers

                expect(json["data"]["attributes"]["name"]).to eq("event_name")
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end

            it "shloud not update event if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop = create :coffee_shop
                event = create :event, coffee_shop: coffee_shop

                put coffee_shop_event_url(coffee_shop, event), params: {
                    "event": {
                        "name": "event_name",
                        "description": "event_description",
                        "opens_at": Time.now + 1.hours,
                        "enrol_start_time": Time.now + 2.hours,
                        "enrol_end_time": Time.now + 3.hours,
                        "event_start_time": Time.now + 4.hours,
                        "event_end_time": Time.now + 5.hours,
                        "closed_at": Time.now + 6.hours
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
        context "when loged in az coffee_owner" do
            it "shloud deactivate event if coffee_owner is owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner
                event =create :event, coffee_shop: coffee_shop

                delete coffee_shop_event_deactivate_url(coffee_shop, event), headers: headers

                expect(Event.find(event.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(event.id) 
            end

            it "shloud not deactivate event if coffee_owner is not owner of the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                event =create :event, coffee_shop: coffee_shop

                delete coffee_shop_event_deactivate_url(coffee_shop, event), headers: headers

                expect(Event.find(event.id).active?).to eq(true)
                
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