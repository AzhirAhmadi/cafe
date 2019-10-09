require 'rails_helper'

RSpec.describe DeviseApi::SessionsController, type: :controller do
    describe "login" do
        context "when invalid params provided" do
            it "(absence of user)" do
                @request.env["devise.mapping"] = Devise.mappings[:user]
                post :create, params: {},
                format: :json

                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}", 
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(absence of email)"do
                @request.env["devise.mapping"] = Devise.mappings[:user]
                post :create, params: {
                    "user":{}
                },
                format: :json
                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}",
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(absence of password)"do
                @request.env["devise.mapping"] = Devise.mappings[:user]
                post :create, params: {
                    "user": {
                        "email": "email"
                    }
                },
                format: :json

                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}", 
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(invalid email)"do

                user = create :player
                @request.env["devise.mapping"] = Devise.mappings[:user]
                post :create, params: {
                    "user": {
                        "email": "invalid",
                        "password": user.password
                    }
                },
                format: :json

                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" : {\"email\" : \"valid email\",\"password\" : \"password\"}}", 
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(invalid of password)"do
                user = create :player
                @request.env["devise.mapping"] = Devise.mappings[:user]
                post :create, params: {
                    "user": {
                        "email": user.email,
                        "password": "invalid"
                    }
                },
                format: :json

                expect(json["error"]).to include(
                        {
                            "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}",
                            "path"=>"devise_api/sessions#create"
                        }
                )
            end
        end



        context "when valid params provieded" do
            it "login by player role and return JWT token" do
                user  = create(:player)
                response = sing_in user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by cafe_owner role and return JWT token" do
                user  = create(:cafe_owner)
                response = sing_in user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by sys_expert role and return JWT token" do
                user  = create(:sys_expert)
                response = sing_in user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by sys_admin role and return JWT token" do
                user  = create(:sys_admin)
                response = sing_in user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by sys_master role and return JWT token" do
                user  = create(:sys_master)
                response = sing_in user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end
        end
    end
end