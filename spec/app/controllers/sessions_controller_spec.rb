require 'rails_helper'

RSpec.describe DeviseApi::SessionsController, type: :request do
    describe "create" do
        context "when invalid body params provided" do
            it "(absence of user)" do
                # @request.env["devise.mapping"] = Devise.mappings[:user]
                post URL(login_path), params: {}
                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}", 
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(absence of email)"do
                # @request.env["devise.mapping"] = Devise.mappings[:user]
                post URL(login_path), params: {
                    "user":{}
                }
                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}",
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(absence of password)"do
                # @request.env["devise.mapping"] = Devise.mappings[:user]
                post URL(login_path), params: {
                    "user": {
                        "email": "email"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"params for login must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\"}}", 
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(invalid email)"do

                user = create :player
                # @request.env["devise.mapping"] = Devise.mappings[:user]
                post URL(login_path), params: {
                    "user": {
                        "email": "invalid",
                        "password": user.password
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Username or password are wrong!", 
                        "path"=>"devise_api/sessions#create"
                    }
                )
            end

            it "(invalid of password)"do
                user = create :player
                # @request.env["devise.mapping"] = Devise.mappings[:user]
                post URL(login_path), params: {
                    "user": {
                        "email": user.email,
                        "password": "invalid"
                    }
                }

                expect(json["error"]).to include(
                        {
                            "message"=>"Username or password are wrong!",
                            "path"=>"devise_api/sessions#create"
                        }
                )
            end
        end

        context "when valid params provieded" do
            it "login by player role and return JWT token" do
                user  = create(:player)
                response = login user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by cafe_owner role and return JWT token" do
                user  = create(:cafe_owner)
                response = login user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by sys_expert role and return JWT token" do
                user  = create(:sys_expert)
                response = login user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by sys_admin role and return JWT token" do
                user  = create(:sys_admin)
                response = login user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end

            it "login by sys_master role and return JWT token" do
                user  = create(:sys_master)
                response = login user
                body = response.body
                expect(json["jwt"]).not_to be_nil
            end
        end
    end

    describe "destroy" do
        context "when invalid header params provided" do
                it "(absence of Authorization Token)" do
                    # @request.env["devise.mapping"] = Devise.mappings[:user]
                    
                    delete URL(logout_path), params: {}
                    expect(json["error"]).to include(
                        {
                            "message"=>"Authorization header needed!", 
                            "path"=>"devise_api/sessions#destroy"
                        }
                    )
                end
        
                it "(invalid Authorization Token)" do
                    headers = {"Authorization": "invalid token"}
                    delete URL(logout_path), params: {}, headers: headers
                    expect(json["error"]).to include(
                        {
                            "message"=>"Wrong jwt token!", 
                            "path"=>"devise_api/sessions#destroy"
                        }
                    )
                end
        end

        context "when valid params provieded" do
            it "logout player by JWT token" do
                user  = create(:player)
                login user
                
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                delete URL(logout_path), headers: headers

                expect(json).to include(
                    {
                        "message"=>"signed out!"
                    }
                )
            end
        end
    end
end