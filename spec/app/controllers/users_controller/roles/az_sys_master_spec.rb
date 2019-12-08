require 'rails_helper'

RSpec.describe UsersController, type: :request do

    describe ".show" do
        context "when loged in az sys_master" do
            it "shloud see users even deactivateds" do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                sys_admin = create :sys_admin
                player = create :player

                get user_url(sys_admin), headers: headers
                expect(json["data"]["id"].to_i).to eql(sys_admin.id)
                expect(json["data"]["attributes"]["deleted_at"]).to eql(nil)

                get user_url(player), headers: headers
                expect(json["data"]["id"].to_i).to eql(player.id)
                expect(json["data"]["attributes"]["deleted_at"]).to eql(nil)

                sys_admin.deleted_at = Time.now
                sys_admin.save
                player.deleted_at = Time.now
                player.save

                get user_url(sys_admin), headers: headers
                expect(json["data"]["id"].to_i).to eql(sys_admin.id)
                expect(json["data"]["attributes"]["deleted_at"]).not_to eql(nil)
                expect(json["data"]["id"].to_i).to eql(sys_admin.id)

                get user_url(player), headers: headers
                expect(json["data"]["id"].to_i).to eql(player.id)
                expect(json["data"]["attributes"]["deleted_at"]).not_to eql(nil)
                expect(json["data"]["id"].to_i).to eql(player.id)
            end
        end
    end

    describe ".index" do
        context "when loged in az sys_master" do
            it "shloud see all users even deactivated users " do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                players = create_list :player, 10
                sys_admins = create_list :sys_admin, 10
                
                get users_url, headers: headers
                
                expect(json["data"].length).to eql(20+1)
                
                for i in 0..3 do
                    players[i].deleted_at = Time.now
                    players[i].save
                    
                    sys_admins[i].deleted_at = Time.now
                    sys_admins[i].save
                end

                get users_url, headers: headers

                expect(json["data"].length).to eql(20+1)
            end
        end
    end

    describe ".create" do
        context "when loged in az sys_master" do
            it "shloud create user and it's role should be 'player' if send role az 'player'" do
                user = create :sys_master
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post users_url, params: {
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

            it "shloud create user and it's role should be 'coffee_owner' if send role az 'coffee_owner'" do
                user = create :sys_master
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post users_url, params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "coffee_owner"
                    }
                }, headers: headers
                newCount = User.count
                expect(newCount - count).to be(1)
                expect(json["data"]["attributes"]["role"]).to eq("coffee_owner")
                expect(json["data"]["attributes"]["email"]).to eq("test@test")
            end

            it "shloud create user and it's role should be 'sys_expert' if send role az 'sys_expert'" do
                user = create :sys_master
                login user
                count = User.count

                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post users_url, params: {
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
                post users_url, params: {
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
                post users_url, params: {
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

    describe ".update" do
        context "when loged in az sys_master" do
            it "shloud update itself and it's role to 'player'" do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
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

            it "shloud update itself and it's role to 'coffee_owner'" do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "coffee_owner"
                    }
                }, headers: headers
                
                logout
                newUser = User.find(user.id)
                newUser.password = "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("coffee_owner")
            end

            it "shloud update itself and it's role to 'sys_expert'" do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "sys_expert"
                    }
                }, headers: headers
                
                logout
                newUser = User.find(user.id)
                newUser.password = "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("sys_expert")
            end

            it "shloud update itself and it's role to 'sys_admin'" do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "sys_admin"
                    }
                }, headers: headers
                
                logout
                newUser = User.find(user.id)
                newUser.password = "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("sys_admin")
            end

            it "shloud update itself and it's role to 'sys_master'" do
                user = create :sys_master
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                put user_url(user), params: {
                    "user": {
                        "email": "new@test",
                        "password": "1234567",
                        "role": "sys_master"
                    }
                }, headers: headers
                logout
                newUser = User.find(user.id)
                newUser.password= "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("sys_master")
            end

            context "and try to update a player" do
                it "shloud update it and it's role to 'player'" do
                    user = create :sys_master
    
                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(player), params: {
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
    
                it "shloud update it and it's role to 'coffee_owner'" do
                    user = create :sys_master
    
                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(player), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "coffee_owner"
                        }
                    }, headers: headers
    
                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq("new@test")
                    expect(saved_player.role).to eq("coffee_owner")
                end
    
                it "shloud update it and it's role to 'sys_expert'" do
                    user = create :sys_master
    
                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(player), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_expert"
                        }
                    }, headers: headers
    
                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq("new@test")
                    expect(saved_player.role).to eq("sys_expert")
                end
    
                it "shloud update it and it's role to 'sys_admin'" do
                    user = create :sys_master
    
                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(player), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_admin"
                        }
                    }, headers: headers
    
                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq("new@test")
                    expect(saved_player.role).to eq("sys_admin")
                end

                it "shloud update it and can't change it's role to upper roles" do
                    user = create :sys_master
    
                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(player), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_master"
                        }
                    }, headers: headers
    
                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq("new@test")
                    expect(saved_player.role).to eq("player")
                end
            end
    
            context "and try to update a coffee_owner" do
                it "shloud update it and it's role to 'player'" do
                    user = create :sys_master
    
                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(coffee_owner), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "player"
                        }
                    }, headers: headers
                    
                    saved_coffee_owner = User.find(coffee_owner.id)
                    expect(saved_coffee_owner.email).to eq("new@test")
                    expect(saved_coffee_owner.role).to eq("player")
                end
    
                it "shloud update it and it's role to 'coffee_owner'" do
                    user = create :sys_master
    
                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(coffee_owner), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "coffee_owner"
                        }
                    }, headers: headers
    
                    saved_coffee_owner = User.find(coffee_owner.id)
                    expect(saved_coffee_owner.email).to eq("new@test")
                    expect(saved_coffee_owner.role).to eq("coffee_owner")
                end
    
                it "shloud update it and it's role to 'sys_expert'" do
                    user = create :sys_master
    
                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(coffee_owner), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_expert"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(coffee_owner.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("sys_expert")
                end

                it "shloud update it and it's role to 'sys_admin'" do
                    user = create :sys_master
    
                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(coffee_owner), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_admin"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(coffee_owner.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("sys_admin")
                end
    
                it "shloud update it and can't change it's role to upper roles" do
                    user = create :sys_master
    
                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(coffee_owner), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_master"
                        }
                    }, headers: headers
    
                    saved_coffee_owner = User.find(coffee_owner.id)
                    expect(saved_coffee_owner.email).to eq("new@test")
                    expect(saved_coffee_owner.role).to eq("coffee_owner")
                end
            end
    
            context "and try to update a sys_expert" do
                it "shloud update it and it's role to 'player'" do
                    user = create :sys_master
    
                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_expert), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "player"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(sys_expert.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("player")
                end
    
                it "shloud update it and it's role to 'coffee_owner'" do
                    user = create :sys_master
    
                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_expert), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "coffee_owner"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(sys_expert.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("coffee_owner")
                end

                it "shloud update it and it's role to 'sys_expert'" do
                    user = create :sys_master
    
                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_expert), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_expert"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(sys_expert.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("sys_expert")
                end

                it "shloud update it and it's role to 'sys_admin'" do
                    user = create :sys_master
    
                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_expert), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_admin"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(sys_expert.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("sys_admin")
                end
    
                it "shloud update it and can't change it's role to upper roles" do
                    user = create :sys_master
    
                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_expert), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_master"
                        }
                    }, headers: headers
    
                    saved_sys_expert = User.find(sys_expert.id)
                    expect(saved_sys_expert.email).to eq("new@test")
                    expect(saved_sys_expert.role).to eq("sys_expert")
                end
            end
    
            context "and try to update a sys_admin" do
                it "shloud update it and it's role to 'player'" do
                    user = create :sys_master
    
                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_admin), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "player"
                        }
                    }, headers: headers
    
                    saved_sys_admin = User.find(sys_admin.id)
                    expect(saved_sys_admin.email).to eq("new@test")
                    expect(saved_sys_admin.role).to eq("player")
                end

                it "shloud update it and it's role to 'coffee_owner'" do
                    user = create :sys_master
    
                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_admin), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "coffee_owner"
                        }
                    }, headers: headers
    
                    saved_sys_admin = User.find(sys_admin.id)
                    expect(saved_sys_admin.email).to eq("new@test")
                    expect(saved_sys_admin.role).to eq("coffee_owner")
                end

                it "shloud update it and it's role to 'sys_expert'" do
                    user = create :sys_master
    
                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_admin), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_expert"
                        }
                    }, headers: headers
    
                    saved_sys_admin = User.find(sys_admin.id)
                    expect(saved_sys_admin.email).to eq("new@test")
                    expect(saved_sys_admin.role).to eq("sys_expert")
                end

                it "shloud update it and it's role to 'sys_admin'" do
                    user = create :sys_master
    
                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_admin), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_admin"
                        }
                    }, headers: headers
    
                    saved_sys_admin = User.find(sys_admin.id)
                    expect(saved_sys_admin.email).to eq("new@test")
                    expect(saved_sys_admin.role).to eq("sys_admin")
                end
    
                it "shloud update it and can't change it's role to upper roles" do
                    user = create :sys_master
    
                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_admin), params: {
                        "user": {
                            "email": "new@test",
                            "password": "1234567",
                            "role": "sys_master"
                        }
                    }, headers: headers
    
                    saved_sys_admin = User.find(sys_admin.id)
                    expect(saved_sys_admin.email).to eq("new@test")
                    expect(saved_sys_admin.role).to eq("sys_admin")
                end
            end
    
            context "and try to update a sys_master" do
                it "shloud get 'Access denied!' error" do
                    user = create :sys_master
    
                    sys_master = create :sys_master
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}
    
                    put user_url(sys_master), params: {
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

    describe ".destroy" do
        context "when loged in az sys_master" do
            it "shloud deactivate itself" do
                user = create :sys_master
                
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                delete user_url(user), headers: headers
                expect(json["data"]["attributes"]["email"]).to eq(user.email)

                login user
                expect(json["error"]["message"]).to include("Your account has been deleted at")
            end

            context "and try to deactivate a player" do
                it "shloud deactivate it" do
                    user = create :sys_master

                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_url(player), headers: headers
                    expect(json["data"]["attributes"]["email"]).to eq(player.email)
                    
                    login player
                    expect(json["error"]["message"]).to include("Your account has been deleted at")
                end
            end

            context "and try to deactivate a coffee_owner" do
                it "shloud deactivate it" do
                    user = create :sys_master

                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_url(coffee_owner), headers: headers
                    expect(json["data"]["attributes"]["email"]).to eq(coffee_owner.email)
                    
                    login coffee_owner
                    expect(json["error"]["message"]).to include("Your account has been deleted at")
                end
            end

            context "and try to deactivate a sys_expert" do
                it "shloud deactivate it" do
                    user = create :sys_master

                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_url(sys_expert), headers: headers
                    expect(json["data"]["attributes"]["email"]).to eq(sys_expert.email)
                    
                    login sys_expert
                    expect(json["error"]["message"]).to include("Your account has been deleted at")
                end
            end

            context "and try to deactivate a sys_admin" do
                it "shloud deactivate it" do
                    user = create :sys_master

                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_url(sys_admin), headers: headers
                    expect(json["data"]["attributes"]["email"]).to eq(sys_admin.email)
                    
                    login sys_admin
                    expect(json["error"]["message"]).to include("Your account has been deleted at")
                end
            end

            context "and try to deactivate a sys_master" do
                it "shloud get 'Access denied!' error" do
                    user = create :sys_master

                    sys_master = create :sys_master
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_url(sys_master), headers: headers

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