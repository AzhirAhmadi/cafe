require 'rails_helper'

RSpec.describe EnrolmentsController, type: :request do
    describe ".create" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                opened_table = create :opened_table
                post coffee_shop_event_table_enrolments_url(opened_table.event.coffee_shop, opened_table.event, opened_table)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"enrolments#create"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                headers = {"Authorization": "invalid"}

                opened_table = create :opened_table
                post coffee_shop_event_table_enrolments_url(opened_table.event.coffee_shop,
                    opened_table.event, opened_table),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"enrolments#create"
                    }
                )
            end
        end
    end
    
    describe ".destroy" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                enrolment = create :enrolment                
                delete coffee_shop_event_table_enrolment_url(enrolment.table.event.coffee_shop, enrolment.table.event, enrolment.table, enrolment)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"enrolments#destroy"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                headers = {"Authorization": "invalid"}
                enrolment = create :enrolment                
                delete coffee_shop_event_table_enrolment_url(enrolment.table.event.coffee_shop, enrolment.table.event, enrolment.table, enrolment),headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!" ,
                        "path"=>"enrolments#destroy"
                    }
                )
            end
        end
    end
end