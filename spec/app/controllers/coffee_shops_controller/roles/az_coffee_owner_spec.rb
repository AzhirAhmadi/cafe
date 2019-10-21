require 'rails_helper'

RSpec.describe CoffeeShopsController, type: :request do
    describe "create" do
        context "when loged in az coffee_owner" do
            it "shloud get 'Access denied!' error" do
                coffee_owner = create :coffee_owner
                login coffee_owner
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
    describe "update" do
        context "when loged in az coffee_owner" do
            it "shloud update coffee_shop data if coffee_owner ownes the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner

                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "new_name",
                        "address": "new_address",
                        "owner_id": 1,
                        "maintainer_id": 1
                    }
                }, headers: headers
                
                expect(json["data"]['attributes']['name']).to include("new_name")
                expect(json["data"]['attributes']['address']).to include("new_address")
            end

            it "shloud not update coffee_shop data if coffee_owner do not ownes the coffee_shop" do
                coffee_owner = create :coffee_owner
                other_coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: other_coffee_owner

                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "new_name",
                        "address": "new_address",
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

            it "shloud not update it's coffee_shop owner or creator or maintainer" do
                coffee_shop_owner = create :coffee_owner
                
                login coffee_shop_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_shop_owner

                other_coffee_shop_owner = create :coffee_owner
                other_coffee_shop_maintainer = create :sys_expert
                other_coffee_shop_creator = create :sys_admin

                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "new_name",
                        "address": "new_address",
                        "owner_id": other_coffee_shop_owner.id,
                        "maintainer_id": other_coffee_shop_maintainer,
                        "creator_id": other_coffee_shop_creator.id
                    }
                }, headers: headers
                
                expect(json["data"]['relationships']['owner']['data']['id'].to_i).to eq(coffee_shop.owner_id)
                expect(json["data"]['relationships']['creator']['data']['id'].to_i).to eq(coffee_shop.creator_id)
            end
        end
    end

    describe "deactivate" do
        context "when loged in az coffee_owner" do

            it "shloud deactivate coffee_shop if coffee_owner ownes the coffee_shop" do
                coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: coffee_owner

                delete coffee_shop_deactivate_url(coffee_shop), headers: headers

                expect(CoffeeShop.find(coffee_shop.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(coffee_shop.id) 
            end

            it "shloud not deactivate coffee_shop if coffee_owner do not ownes the coffee_shop" do
                coffee_owner = create :coffee_owner
                other_coffee_owner = create :coffee_owner
                login coffee_owner
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop, owner: other_coffee_owner

                delete coffee_shop_deactivate_url(coffee_shop), headers: headers
                
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