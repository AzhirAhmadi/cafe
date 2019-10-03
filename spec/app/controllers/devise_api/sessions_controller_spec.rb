require 'rails_helper'

RSpec.describe DeviseApi::SessionsController do
    describe "#create" do
        subject { post :create, params: params}

        context "when invalid data provided" do
            let(:params) do
                {
                    "user":{
                        "email":nil,
                        "password":nil
                    }
                }
            end
            
            it "should return unprocessable_entity status code" do
                subject
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it "should not create a user" do
                expect{subject}.not_to change{ User.count}
            end

            it "shloud retrun error messages in response body" do
                subject

                expect(json["errors"]).to include(
                    {
                        "source" => { "pointer" => "/data/attributes/login"},
                        "detail" => "can't be blank"
                    },
                    {
                        "source" => { "pointer" => "/data/attributes/password"},
                        "detail" => "can't be blank"
                    }
                )
            end
        end

    end
end