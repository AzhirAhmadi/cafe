require 'rails_helper'

RSpec.describe UsersController, type: :request do
    describe "create" do
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
    end

    describe "update" do
        context "when loged in az cafe_owner" do
            it "shloud update itself and it's role to 'player'" do
                user = create :cafe_owner
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                
                logout
                newUser = User.find(user.id)
                newUser.password = "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("player")
            end

            it "shloud update itself and it's role to 'cafe_owner'" do
                user = create :cafe_owner
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "cafe_owner"
                    }
                }, headers: headers
                
                logout
                newUser = User.find(user.id)
                newUser.password = "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("cafe_owner")
            end

            it "shloud update itself and can't change it's role to upper roles" do
                user = create :cafe_owner
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put URL(user_path(user)), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "sys_expert"
                    }
                }, headers: headers
                logout
                newUser = User.find(user.id)
                newUser.password= "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("cafe_owner")
            end

            context "and try to update a player" do
                it "shloud update it and it's role to 'player'" do
                    user = create :cafe_owner

                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    put URL(user_path(player)), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "player"
                        }
                    }, headers: headers

                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq("new@test")
                    expect(saved_player.role).to eq("player")
                end

                it "shloud update it and can't change it's role to upper roles" do
                    user = create :cafe_owner

                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    put URL(user_path(player)), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "cafe_owner"
                        }
                    }, headers: headers

                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq("new@test")
                    expect(saved_player.role).to eq("player")
                end
            end

            context "and try to update a cafe_owner" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    cafe_owner = create :cafe_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                    
                    put URL(user_path(cafe_owner)), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "cafe_owner"
                        }
                    }, headers: headers

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                            }
                    })
                    saved_cafe_owner = User.find(cafe_owner.id)
                    expect(saved_cafe_owner.email).to eq(cafe_owner.email)
                    expect(saved_cafe_owner.role).to eq(cafe_owner.role)
                end
            end

            context "and try to update a sys_expert" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    put URL(user_path(sys_expert)), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_expert"
                        }
                    }, headers: headers
                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                            }
                    })
                    saved_sys_expert = User.find(sys_expert.id)
                    expect(saved_sys_expert.email).to eq(sys_expert.email)
                    expect(saved_sys_expert.role).to eq(sys_expert.role)
                end
            end

            context "and try to update a sys_admin" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    put URL(user_path(sys_admin)), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_admin"
                        }
                    }, headers: headers
                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                            }
                    })
                    saved_sys_admin = User.find(sys_admin.id)
                    expect(saved_sys_admin.email).to eq(sys_admin.email)
                    expect(saved_sys_admin.role).to eq(sys_admin.role)
                end
            end

            context "and try to update a sys_master" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    sys_master = create :sys_master
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    put URL(user_path(sys_master)), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_master"
                        }
                    }, headers: headers
                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                            }
                    })
                    saved_sys_master = User.find(sys_master.id)
                    expect(saved_sys_master.email).to eq(sys_master.email)
                    expect(saved_sys_master.role).to eq(sys_master.role)
                end
            end
        end
    end

    describe "deactivate" do
        context "when loged in az cafe_owner" do
            it "shloud deactivate itself" do
                user = create :cafe_owner
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                delete URL(user_deactivate_path(user)), headers: headers
                expect(json["data"]["attributes"]["email"]).to eq(user.email)

                login user
                expect(json["error"]["message"]).to include("Your account has been deleted at")
            end

            context "and try to deactivate a player" do
                it "shloud deactivate it" do
                    user = create :cafe_owner

                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete URL(user_deactivate_path(player)), headers: headers
                    expect(json["data"]["attributes"]["email"]).to eq(player.email)
                    
                    login player
                    expect(json["error"]["message"]).to include("Your account has been deleted at")
                end
            end

            context "and try to deactivate a cafe_owner" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    cafe_owner = create :cafe_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete URL(user_deactivate_path(cafe_owner)), headers: headers

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                        }
                    })
                end
            end

            context "and try to deactivate a sys_expert" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete URL(user_deactivate_path(sys_expert)), headers: headers

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                        }
                    })
                end
            end

            context "and try to deactivate a sys_admin" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete URL(user_deactivate_path(sys_admin)), headers: headers

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                        }
                    })
                end
            end

            context "and try to deactivate a sys_master" do
                it "shloud get 'Access denied!' error" do
                    user = create :cafe_owner

                    sys_master = create :sys_master
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete URL(user_deactivate_path(sys_master)), headers: headers

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                        }
                    })
                end
            end
        end
    end
end