require 'rails_helper'

RSpec.describe CoffeeShopsController, type: :request do
    describe ".show" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                creator = create :player

                coffee_shop = create :coffee_shop
                get coffee_shop_url(coffee_shop)

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"coffee_shops#show"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                creator = create :player
                login creator
                headers = {"Authorization": "invalid"}
                
                coffee_shop = create :coffee_shop

                get coffee_shop_url(coffee_shop), headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Wrong jwt token!", 
                        "path"=>"coffee_shops#show"
                    }
                )
            end
        end
    end
    describe ".index" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                creator = create :player

                coffee_shop = create :coffee_shop
                get coffee_shops_url

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"coffee_shops#index"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                creator = create :player
                login creator
                headers = {"Authorization": "invalid"}
                
                coffee_shop = create :coffee_shop

                get coffee_shops_url, headers: headers

                expect(json["error"]).to include(
                    {
                        "message"=>"Wrong jwt token!", 
                        "path"=>"coffee_shops#index"
                    }
                )
            end
        end
    end

    describe ".create" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                creator = create :player

                post coffee_shops_url, params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"coffee_shops#create"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                creator = create :player
                login creator
                headers = {"Authorization": "invalid"}
                post coffee_shops_url, params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil",
                        "owner_id": "nil"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Wrong jwt token!", 
                        "path"=>"coffee_shops#create"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of coffee_shop)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                post coffee_shops_url, params: {

                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#create"
                    }
                )
            end

            it "(absence of name)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                post coffee_shops_url, params: {
                    "coffee_shop": {}
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#create"
                    }
                )
            end

            it "(absence of address)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                post coffee_shops_url, params: {
                    "coffee_shop":{
                        "name": "nil"
                    }
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#create"
                    }
                )
            end

            it "(absence of owner_id)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                post coffee_shops_url, params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil"
                    }
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for create coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#create"
                    }
                )
            end
        end
    end


    describe ".update" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                creator = create :player
                coffee_shop = create :coffee_shop

                put coffee_shop_url(coffee_shop), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"coffee_shops#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                creator = create :player
                coffee_shop = create :coffee_shop

                login creator
                headers = {"Authorization": "invalid"}
                put coffee_shop_url(coffee_shop), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Wrong jwt token!", 
                        "path"=>"coffee_shops#update"
                    }
                )
            end
        end

        context "when invalid body params provided" do
            it "(absence of coffee_shop)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                coffee_shop = create :coffee_shop

                put coffee_shop_url(coffee_shop), params: {

                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#update"
                    }
                )
            end

            it "(absence of name)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                coffee_shop = create :coffee_shop
                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop": {"test": "test"}
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#update"
                    }
                )
            end

            it "(absence of address)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                coffee_shop = create :coffee_shop
                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "nil"
                    }
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#update"
                    }
                )
            end

            it "(absence of owner_id)" do
                creator = create :player
                login creator
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                coffee_shop = create :coffee_shop
                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "nil",
                        "address": "nil"
                    }
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "message"=>"params for update coffee_shop must be provided like this: {\"coffee_shop\" :{\"name\" : \"coffee_shop_name\", \"address\":\"coffee_shop_address\", \"owner_id\": \"coffee_shop_owner_id\", \"maintainer_id\": \"coffee_shop_maintainer_id\"}}",
                        "path"=>"coffee_shops#update"
                    }
                )
            end
        end
    end

    describe ".deactivate" do
        context "when invalid header params provided" do
            it "(absence of Authorization Token)" do
                creator = create :player
                coffee_shop = create :coffee_shop

                put coffee_shop_url(coffee_shop), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }

                expect(json["error"]).to include(
                    {
                        "message"=>"Authorization header needed!", 
                        "path"=>"coffee_shops#update"
                    }
                )
            end
    
            it "(invalid Authorization Token)" do
                creator = create :player
                coffee_shop = create :coffee_shop

                login creator
                headers = {"Authorization": "invalid"}
                put coffee_shop_url(coffee_shop), params: {
                    "user": {
                        "email": "test@test",
                        "password": "1234567",
                        "role": "player"
                    }
                }, headers: headers
                expect(json["error"]).to include(
                    {
                        "message"=>"Wrong jwt token!", 
                        "path"=>"coffee_shops#update"
                    }
                )
            end
        end

    end
end