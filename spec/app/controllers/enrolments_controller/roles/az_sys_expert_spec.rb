require 'rails_helper'

RSpec.describe EnrolmentsController, type: :request do
    describe ".create" do
        context "when loged in az sys_expert" do
            it "should create an enrolment on a table for loged in user" do
                sys_expert = create :sys_expert
                login sys_expert
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                opened_table = create :opened_table
                count = Enrolment.count
                post coffee_shop_event_table_enrolments_url(opened_table.event.coffee_shop, opened_table.event, opened_table),
                 params: {}, headers: headers
                newCount = Enrolment.count

                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["user"]["id"]).to eql(sys_expert.id)
                expect(json["data"]["attributes"]["table"]["id"]).to eql(opened_table.id)
            end
        end
    end

    describe ".destroy" do
        context "when loged in az sys_expert" do
            it "should destroy an enrolment on a table for loged in user" do
                sys_expert = create :sys_expert
                login sys_expert
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                enrolment = create :enrolment, user: sys_expert

                delete coffee_shop_event_table_enrolment_url(enrolment.table.event.coffee_shop, enrolment.table.event, enrolment.table, enrolment), headers: headers

                expect(Enrolment.find(enrolment.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(enrolment.id)
                expect(json["data"]["attributes"]["user"]["id"]).to eql(enrolment.user.id)
                expect(json["data"]["attributes"]["table"]["id"]).to eql(enrolment.table.id)

            end
        end
    end
end