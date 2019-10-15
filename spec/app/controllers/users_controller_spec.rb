require 'rails_helper'

RSpec.describe UsersController, type: :request do
    describe "create" do
        context "when invalid body params provided" do
            it "(absence of user)" do
                post URL(users_path), params: {}

                expect(json["error"]).to include(
                    {
                        "message"=>"params for sign_up must be provided like this: {\"user\" :{\"email\" : \"valid email\",\"password\" : \"password\", \"role\":\"player\"}}",
                        "path"=>"users#create"
                    }
                )
            end

            it "(absence of email)" do
                post URL(users_path), params: {
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
                post URL(users_path), params: {
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
                post URL(users_path), params: {
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
                post URL(users_path), params: {
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
                post URL(users_path), params: {
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
                post URL(users_path), params: {
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

            it "shloud create user and it's role should be 'player' if send role az 'cafe_owner'" do
                count = User.count
                    post URL(users_path), params: {
                        "user": {
                            "email": "test@test",
                            "password": "1234567",
                            "role": "cafe_owner"
                        }
                    }
    
                    newCount = User.count
                    expect(newCount - count).to be(1)
                    expect(json["data"]["attributes"]["role"]).to eq("player")
                    expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_expert'" do
                count = User.count
                    post URL(users_path), params: {
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
                    post URL(users_path), params: {
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
                    post URL(users_path), params: {
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
                        put URL(user_path(user)), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }
                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"users#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                user = create :player
                login user
                headers = {"Authorization": "invalid"}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Wrong jwt token!", 
                        "path"=>"users#update"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of user)" do
                user = create :player
                login user
                headers = {"Authorization": token}
                put URL(user_path(user)), params: {

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
                headers = {"Authorization": token}
                put URL(user_path(user)), params: {
                    "user": {
                    }
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
                headers = {"Authorization": token}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": ""
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
                headers = {"Authorization": token}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "",
                        "password": ""
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
                headers = {"Authorization": token}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "invalid",
                        "password": "123456",
                        "role": "player",
                        "tji": "13e2de23e4x34e"
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
                headers = {"Authorization": token}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1",
                        "role": "player",
                        "tji": "13e2de23e4x34e"
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
end