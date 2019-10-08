module SharedHelper

    shared_examples_for "Authorization_token_absence" do

        it "should return 500 status code" do
            subject
            expect(response).to have_http_status(500)
        end

        it "should return proper error body" do
            subject
            puts json: response.body
            expect(json).to include("Authorization header needed!")
        end
    end

    shared_examples_for "unauthorized_oauth_requests" do
        let(:error) do
            {
                "status" => 401,
                "source" => { "pointer" => "/code" },
                "title" => "Authentication code is invalid",
                "detail" => "You must provide valid code in order to exchange it for token."
            }
        end

        it "should return 401 status code" do
            subject
            expect(response).to have_http_status(401)
        end

        it "should return proper error body" do
            subject
            expect(json["errors"]).to include(error)
        end
    end
                         
    shared_examples_for "forbidden_requests" do
        it "should return 403 status code" do
            subject
            expect(response).to have_http_status(:forbidden)
        end

        it "should return proper error json" do
            authorization_error = {
                "status" => 403,
                "source" => { "pointer" => "/headers/authorization" },
                "title" => "Not authorized",
                "detail" => "You have no right to access this resource."
            }
            subject
            expect(json["errors"]).to eq(authorization_error)
        end
    end
end