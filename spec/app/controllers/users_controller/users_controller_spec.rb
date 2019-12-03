require 'rails_helper'

RSpec.describe UsersController, type: :request do
    describe "show" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                user = create :player
                login user
                get user_url(user)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"users#show"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                user = create :player
                login user
                headers = {"Authorization": "invalid"}
                get user_url(user), headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!", 
                        "path"=>"users#show"
                    }
                )
            end
        end
    end

    describe "index" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                user = create :player
                login user
                get users_url

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"users#index"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                user = create :player
                login user
                headers = {"Authorization": "invalid"}
                get users_url, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!", 
                        "path"=>"users#index"
                    }
                )
            end
        end
    end

    describe "create" do
        context "when invalid body params provided" do
            it "(absence of user)" do
                post users_url, params: {}

                expect(json["error"]).to include(
                    {
                        "message"=>"params for sign_up must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#create"
                    }
                )
            end

            it "(absence of email)" do
                post users_url, params: {
                    "user": {
                    }
                }
                expect(json["error"]).to include(
                    {
                        "message"=>"params for sign_up must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#create"
                    }
                )
            end

            it "(absence of password)" do
                post users_url, params: {
                    "user": {
                        "email": ""
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"params for sign_up must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#create"
                    }
                )
            end

            it "(absence of role)" do
                post users_url, params: {
                    "user": {
                        "email": "",
                        "password": ""
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"params for sign_up must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#create"
                    }
                )
            end

            it "(invalid email)" do
                post users_url, params: {
                    "user": {
                        "email": "invalid",
                        "password": "123456",
                        "role": "player",
                        "tji": "13e2de23e4x34e"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>{"email"=>["is invalid"]}, 
                        "path"=>"users#create"
                    }
                )
            end

            it "(invalid of password)"do
                post users_url, params: {
                    "user": {
                        "email": "test@test",
                        "password": "1",
                        "role": "player"
                    }
                }

                expect(json["error"]).to include(
                        {
                            "message"=>{"password"=>["is too short (minimum is 6 characters)"]},
                            "path"=>"users#create"
                        }
                )
            end
        end

        context "when no one is loged in" do
            it "shloud create user and it's role should be 'player' if send role az 'player'" do
                count = User.count
                post users_url, params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }

                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'coffee_owner'" do
                count = User.count
                    post users_url, params: {
                        "user": {
                            "email": "test@test",
                            "password": "1234567",
                            "role": "coffee_owner"
                        }
                    }
    
                    newCount = User.count
                    expect(newCount - count).to be(1)
                    expect(json["data"]["attributes"]["role"]).to eq("player")
                    expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_expert'" do
                count = User.count
                    post users_url, params: {
                        "user": {
                            "email": "test@test",
                            "password": "1234567",
                            "role": "sys_expert"
                        }
                    }
    
                    newCount = User.count
                    expect(newCount - count).to be(1)
                    expect(json["data"]["attributes"]["role"]).to eq("player")
                    expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_admin'" do
                count = User.count
                    post users_url, params: {
                        "user": {
                            "email": "test@test",
                            "password": "1234567",
                            "role": "sys_admin"
                        }
                    }
    
                    newCount = User.count
                    expect(newCount - count).to be(1)
                    expect(json["data"]["attributes"]["role"]).to eq("player")
                    expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_master'" do
                count = User.count
                    post users_url, params: {
                        "user": {
                            "email": "test@test",
                            "password": "1234567",
                            "role": "sys_master"
                        }
                    }
    
                    newCount = User.count
                    expect(newCount - count).to be(1)
                    expect(json["data"]["attributes"]["role"]).to eq("player")
                    expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end
        end
    end
    describe "update" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                user = create :player
                login user
                        put user_url(user), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }
                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"users#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                user = create :player
                login user
                headers = {"Authorization": "invalid"}
                put user_url(user), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!", 
                        "path"=>"users#update"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of user)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {

                }, headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#update"
                    }
                )
            end

            it "(absence of email)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {"tets": "test"}
                }, headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#update"
                    }
                )
            end

            it "(absence of password)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "email"
                    }
                }, headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#update"
                    }
                )
            end

            it "(absence of role)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "email",
                        "password": "password"
                    }
                }, headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"params for update must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#update"
                    }
                )
            end

            it "(invalid email)" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "invalid",
                        "password": "123456",
                        "role": "player"
                    }
                }, headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>{"email"=>["is invalid"]}, 
                        "path"=>"users#update"
                    }
                )
            end

            it "(invalid of password)"do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1",
                        "role": "player"
                    }
                }, headers: headers

                expect(json["error"]).to include(
                        {
                            "message"=>{"password"=>["is too short (minimum is 6 characters)"]},
                            "path"=>"users#update"
                        }
                )
            end
        end
    end

    describe "deactivate" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                user = create :player
                login user
                delete user_deactivate_url(user)

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"users#deactivate"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                user = create :player
                login user
                headers = {"Authorization": "invalid"}
                delete user_deactivate_url(user), headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!", 
                        "path"=>"users#deactivate"
                    }
                )
            end
        end
    end

    describe "profile" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                user = create :player
                login user
                get profile_url

                expect(json["error"]).to include(
                    {
                        "message"=>"Bad Request!", 
                        "path"=>"users#profile"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                user = create :player
                login user
                headers = {"Authorization": "invalid"}
                get profile_url, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Not Acceptable!", 
                        "path"=>"users#profile"
                    }
                )
            end
        end

        it "should return user's data" do
            user = create :player
            login user
            headers = {"Authorization":  JSON.parse(response.body)["jwt"]}

            get profile_url, headers: headers
            expect(json["data"]["attributes"]["email"]).to eq(user.email)
            expect(json["data"]["attributes"]["role"]).to eq(user.role)
        end
    end
end