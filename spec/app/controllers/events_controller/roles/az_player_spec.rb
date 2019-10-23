require 'rails_helper'

RSpec.describe EventsController, type: :request do
    describe "#create" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                coffee_shop =create :coffee_shop
                count = BoardGame.count
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
                puts json
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

    describe "deactivate" do
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