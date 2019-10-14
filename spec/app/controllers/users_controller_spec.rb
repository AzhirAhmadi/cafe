require 'rails_helper'

RSpec.describe UsersController, type: :request do
    describe "create" do
        # context "when invalid header params provided" do
        #     it "(absence of Authorization Token)" do
                # @request.env["devise.mapping"] = Devise.mappings[:user]
                
        #         post URL(users_path), params
        #         expect(json["error"]).to include(
        #             {
        #                 "message"=>"Authorization header needed!", 
        #                 "path"=>"devise_api/sessions#destroy"
        #             }
        #         )
        #     end
    
        #     it "(invalid Authorization Token)" do
                # @request.env["devise.mapping"] = Devise.mappings[:user]
        #         @request.headers["Authorization"] = "invalid token"
    
        #         post URL(users_path), params
        #         expect(json["error"]).to include(
        #             {
        #                 "message"=>"Wrong jwt token!", 
        #                 "path"=>"devise_api/sessions#destroy"
        #             }
        #         )
        #     end
        # end
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

        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                user = create :player
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                newCount = User.all.count
                expect(newCount - count).to eq(0)
                expect(json["error"]).to include(
                    {
                        "class" => "Pundit::NotAuthorizedError",
                        "text" => "Access denied!"
                    }
                )
            end
        end

        context "when loged in az cafe_owner" do
            it "shloud create user and it's role should be 'player' if send role az 'player'" do
                user = create :cafe_owner
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'cafe_owner'" do
                user = create :cafe_owner
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "cafe_owner"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_expert'" do
                user = create :cafe_owner
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_expert"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_admin'" do
                user = create :cafe_owner
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_admin"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_master'" do
                user = create :cafe_owner
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_master"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end
        end

        context "when loged in az sys_expert" do
            it "shloud create user and it's role should be 'player' if send role az 'player'" do
                user = create :sys_expert
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'cafe_owner' if send role az 'cafe_owner'" do
                user = create :sys_expert
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "cafe_owner"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("cafe_owner")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_expert'" do
                user = create :sys_expert
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_expert"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_admin'" do
                user = create :sys_expert
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_admin"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_master'" do
                user = create :sys_expert
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_master"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end
        end

        context "when loged in az sys_admin" do
            it "shloud create user and it's role should be 'player' if send role az 'player'" do
                user = create :sys_admin
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'cafe_owner' if send role az 'cafe_owner'" do
                user = create :sys_admin
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "cafe_owner"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("cafe_owner")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'sys_expert' if send role az 'sys_expert'" do
                user = create :sys_admin
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_expert"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("sys_expert")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_admin'" do
                user = create :sys_admin
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_admin"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_master'" do
                user = create :sys_admin
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_master"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end
        end

        context "when loged in az sys_master" do
            it "shloud create user and it's role should be 'player' if send role az 'player'" do
                user = create :sys_master
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'cafe_owner' if send role az 'cafe_owner'" do
                user = create :sys_master
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "cafe_owner"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("cafe_owner")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'sys_expert' if send role az 'sys_expert'" do
                user = create :sys_master
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_expert"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("sys_expert")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'sys_admin' if send role az 'sys_admin'" do
                user = create :sys_master
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_admin"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("sys_admin")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'player' if send role az 'sys_master'" do
                user = create :sys_master
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post URL(users_path), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "sys_master"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("player")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end
        end
    end
end