module SharedHelper

    shared_examples_for "bad_Authorization_token" do

        it "(absence of Authorization Token in header)" do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            delete :destroy, params: {}, format: :json

            expect(json["error"]).to include(
                {
                    "message"=>"Authorization header needed!", 
                    "path"=>"devise_api/sessions#destroy"
                }
            )
        end

        it "(invalid Authorization Token in header)" do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            @request.headers["Authorization"] = "invalid token"

            delete :destroy, params: {}, format: :json
            expect(json["error"]).to include(
                {
                    "message"=>"Wrong jwt token!", 
                    "path"=>"devise_api/sessions#destroy"
                }
            )
        end
    end

end