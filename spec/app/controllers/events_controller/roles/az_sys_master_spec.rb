require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe ".show" do
        context "when loged in az sys_admin" do
            it "shloud see open event in coffee_shop" do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                
                get coffee_shop_event_url(coffee_shop, opened_event), headers: headers
                expect(json["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)
            end

            it "shloud see locked event in coffee_shop" do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                locked_event = create :locked_event, coffee_shop: coffee_shop

                get coffee_shop_event_url(coffee_shop, locked_event), headers: headers
                expect(json["data"]["id"].to_i).to eql(locked_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)
            end

            it "shloud not see event which is not in coffee_shop" do
                sys_admin = create :sys_admin
                login sys_admin
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

            it "shloud see deactivated event" do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                opened_event = create :opened_event, coffee_shop: coffee_shop
                opened_event.deleted_at = Time.now
                opened_event.save

                get coffee_shop_event_url(coffee_shop, opened_event), headers: headers
                expect(json["data"]["id"].to_i).to eql(opened_event.id)
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eql(coffee_shop.id)
            end
        end
    end

    describe ".index" do
        context "when loged in az sys_admin" do
            it "shloud see all events in coffee_shop" do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                # 6 event
                opened_event = create :opened_event, coffee_shop: coffee_shop
                enroled_event = create :enroled_event, coffee_shop: coffee_shop
                started_event = create :started_event, coffee_shop: coffee_shop
                ended_event = create :ended_event, coffee_shop: coffee_shop
                closed_event = create :closed_event, coffee_shop: coffee_shop
                locked_event = create :locked_event, coffee_shop: coffee_shop

                opened_event.deleted_at = Time.now
                opened_event.save

                get coffee_shop_events_url(coffee_shop), headers: headers
                expect(json["data"].length).to eql(6)
            end
        end
    end
    
    describe ".create" do
        context "when loged in az sys_master" do
            it "shloud create event" do
                sys_master = create :sys_master
                login sys_master
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
                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["name"]).to eq("event_name")
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end
        end
    end
    describe ".update" do
        context "when loged in az sys_master" do
            it "shloud update event" do
                sys_master = create :sys_master
                login sys_master
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

                expect(json["data"]["attributes"]["name"]).to eq("event_name")
                expect(json["data"]["relationships"]["coffee_shop"]["data"]["id"].to_i).to eq(coffee_shop.id)
            end
        end
    end

    describe ".deactivate" do
        context "when loged in az sys_master" do
            it "shloud deactivate event" do
                sys_master = create :sys_master
                login sys_master
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                event =create :event, coffee_shop: coffee_shop

                delete coffee_shop_event_deactivate_url(coffee_shop, event), headers: headers

                expect(Event.find(event.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(event.id) 
            end
        end
    end
end