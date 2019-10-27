require 'rails_helper'

RSpec.describe UsersController, type: :request do
    describe "show" do
        context "when loged in az player" do
            it "shloud not see deactivated users " do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                player = create :player
                get user_url(player), headers: headers

                expect(json["data"]["id"].to_i).to eql(player.id)
                
                player.deleted_at = Time.now
                player.save

                get user_url(player), headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find User"
                    }
                })
            end
        end
    end

    describe "index" do
        context "when loged in az player" do
            it "shloud not see deactivated users " do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                players = create_list :player, 10
                
                get users_url, headers: headers
                
                expect(json["data"].length).to eql(10+1)
                
                for i in 0..3 do
                    players[i].deleted_at = Time.now
                    players[i].save    
                end

                get users_url, headers: headers

                expect(json["data"].length).to eql(6+1)
            end
        end
    end

    describe "create" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                user = create :player
                login user
                count = User.count
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                post users_url, params:{
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
    end
    describe "update" do
        context "when loged in az player" do
            it "shloud update itself and it's role to 'player'" do
                user = create :player
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

            it "shloud update itself and can't change it's role to upper roles" do
                user = create :player
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
                newUser.password= "1234567"
                login newUser

                expect(token).not_to eq(nil)
                expect(User.find(user.id).email).to eq("new@test")
                expect(User.find(user.id).role).to eq("player")
            end

            context "and try to update a player" do
                it "shloud get 'Access denied!' error" do
                    user = create :player

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

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                            }
                    })
                    saved_player = User.find(player.id)
                    expect(saved_player.email).to eq(player.email)
                    expect(saved_player.role).to eq(player.role)
                end
            end

            context "and try to update a coffee_owner" do
                it "shloud get 'Access denied!' error" do
                    user = create :player

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
                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                            }
                    })
                    saved_coffee_owner = User.find(coffee_owner.id)
                    expect(saved_coffee_owner.email).to eq(coffee_owner.email)
                    expect(saved_coffee_owner.role).to eq(coffee_owner.role)
                end
            end

            context "and try to update a sys_expert" do
                it "shloud get 'Access denied!' error" do
                    user = create :player

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
                    user = create :player

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
                    user = create :player

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

    describe "deactivate" do
        context "when loged in az player" do
            it "shloud deactivate itself" do
                user = create :player
                login user
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                delete user_deactivate_url(user), headers: headers
                login user

                expect(json["error"]["message"]).to include("Your account has been deleted at")
            end

            context "and try to deactivate a player" do
                it "shloud get 'Access denied!' error" do
                    user = create :player

                    player = create :player
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_deactivate_url(player), headers: headers

                    expect(json).to include({
                        "error"=>{
                                "text"=>"Access denied!",
                                "class"=>"Pundit::NotAuthorizedError"
                        }
                    })
                end
            end

            context "and try to deactivate a coffee_owner" do
                it "shloud get 'Access denied!' error" do
                    user = create :player

                    coffee_owner = create :coffee_owner
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_deactivate_url(coffee_owner), headers: headers

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
                    user = create :player

                    sys_expert = create :sys_expert
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_deactivate_url(sys_expert), headers: headers

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
                    user = create :player

                    sys_admin = create :sys_admin
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_deactivate_url(sys_admin), headers: headers

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
                    user = create :player

                    sys_master = create :sys_master
                    
                    login user
                    headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                    delete user_deactivate_url(sys_master), headers: headers

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