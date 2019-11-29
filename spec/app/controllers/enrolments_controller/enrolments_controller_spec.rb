require 'rails_helper'

RSpec.describe EnrolmentsController, type: :request do
    describe ".create" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                opened_event = create :opened_event

                post coffee_shop_event_enrolments_url(opened_event.coffee_shop, opened_event)

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"enrolments#create"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                headers = {"Authorization": "invalid"}

                opened_event = create :opened_event

                post coffee_shop_event_enrolments_url(opened_event.coffee_shop, opened_event),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Unauthorized!" ,
                        "path"=>"enrolments#create"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of enrolment)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_event = create :opened_event
                post coffee_shop_event_enrolments_url(opened_event.coffee_shop, opened_event), params: {

                },headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create enrolment must be provided like this:{\"enrolment\" :{\"table_id\" : \"id\"}}",
                        "path"=>"enrolments#create"
                    }
                )
            end

            it "(absence of tabel_id)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                opened_event = create :opened_event
                post coffee_shop_event_enrolments_url(opened_event.coffee_shop, opened_event), params: {
                    "enrolment": {
                        "test": "test"
                    }
                },headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create enrolment must be provided like this:{\"enrolment\" :{\"table_id\" : \"id\"}}",
                        "path"=>"enrolments#create"
                    }
                )
            end
        end
    end
    
    describe ".deactivate" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                enrolment = create :enrolment                
                delete coffee_shop_event_enrolment_deactivate_url(enrolment.table.event.coffee_shop, enrolment.table.event, enrolment)

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"enrolments#deactivate"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                headers = {"Authorization": "invalid"}
                enrolment = create :enrolment                
                delete coffee_shop_event_enrolment_deactivate_url(enrolment.table.event.coffee_shop, enrolment.table.event, enrolment),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Unauthorized!" ,
                        "path"=>"enrolments#deactivate"
                    }
                )
            end
        end
    end
end