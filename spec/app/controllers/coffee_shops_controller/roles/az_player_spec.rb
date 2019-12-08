require 'rails_helper'

RSpec.describe CoffeeShopsController, type: :request do
    describe ".show" do
        context "when loged in az player" do
            it "shloud not see deactivated coffee_shops " do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                get coffee_shop_url(coffee_shop), headers: headers

                expect(json["data"]["id"].to_i).to eql(coffee_shop.id)
                
                coffee_shop.deleted_at = Time.now
                coffee_shop.save

                get coffee_shop_url(coffee_shop), headers: headers

                expect(json).to include({
                    "error"=>{
                        "message"=>"Couldn't find coffee shop"
                    }
                })
            end
        end
    end

    describe ".index" do
        context "when loged in az player" do
            it "shloud not see deactivated coffee_shops " do
                coffee_owner = create :player
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shops = create_list :coffee_shop, 10
                
                get coffee_shops_url, headers: headers
                
                expect(json["data"].length).to eql(10)
                
                for i in 0..3 do
                    coffee_shops[i].deleted_at = Time.now
                    coffee_shops[i].save    
                end

                get coffee_shops_url, headers: headers

                expect(json["data"].length).to eql(6)
            end
        end
    end

    describe ".create" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                count = CoffeeShop.count
                post coffee_shops_url, params: {
                    "coffee_shop":{
                        "name": "name",
                        "address": "address",
                        "owner_id": 1,
                        "maintainer_id": 1
                    }
                }, headers: headers
                
                newCount = CoffeeShop.count

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
    describe ".update" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "name",
                        "address": "address",
                        "owner_id": 1,
                        "maintainer_id": 1
                    }
                }, headers: headers
                
                expect(json["error"]).to include(
                    {
                        "class" => "Pundit::NotAuthorizedError",
                        "text" => "Access denied!"
                    }
                )
            end
        end
    end

    describe ".destroy" do
        context "when loged in az player" do
            it "shloud get 'Access denied!' error" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                delete coffee_shop_url(coffee_shop), headers: headers
                
                expect(json["error"]).to include(
                    {
                        "class" => "Pundit::NotAuthorizedError",
                        "text" => "Access denied!"
                    }
                )
            end
        end
    end
end