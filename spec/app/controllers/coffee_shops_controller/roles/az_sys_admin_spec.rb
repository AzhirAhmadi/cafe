require 'rails_helper'

RSpec.describe CoffeeShopsController, type: :request do
    describe ".show" do
        context "when loged in az sys_admin" do
            it "shloud see all coffee_shops " do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                get coffee_shop_url(coffee_shop), headers: headers

                expect(json["data"]["id"].to_i).to eql(coffee_shop.id)
                
                coffee_shop.deleted_at = Time.now
                coffee_shop.save

                get coffee_shop_url(coffee_shop), headers: headers
                expect(json["data"]["id"].to_i).to eql(coffee_shop.id)
                expect(json["data"]["attributes"]["deleted_at"]).not_to eql(nil)
                expect(json["data"]["id"].to_i).to eql(coffee_shop.id)
            end
        end
    end

    describe ".index" do
        context "when loged in az sys_admin" do
            it "shloud see all coffee_shops " do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shops = create_list :coffee_shop, 10
                
                get coffee_shops_url, headers: headers
                
                expect(json["data"].length).to eql(10)
                
                for i in 0..3 do
                    coffee_shops[i].deleted_at = Time.now
                    coffee_shops[i].save    
                end

                get coffee_shops_url, headers: headers

                expect(json["data"].length).to eql(10)
            end
        end
    end

    describe "create" do
        context "when loged in az sys_admin" do
            it "shloud create coffee_shop and be creator of the coffee_shop" do
                sys_admin = create :sys_admin

                coffee_shop_maintainer = create :sys_expert
                coffee_shop_owner = create :coffee_owner

                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                count = CoffeeShop.count
                post coffee_shops_url, params: {
                    "coffee_shop":{
                        "name": "coffeeShopName",
                        "address": "coffeeShopAddress",
                        "owner_id": coffee_shop_owner.id,
                        "maintainer_id": coffee_shop_maintainer.id
                    }
                }, headers: headers
                
                newCount = CoffeeShop.count

                expect(newCount - count).to eq(1)
                expect(json['data']['relationships']['owner']['data']['id'].to_i).to eq(coffee_shop_owner.id)
                expect(json['data']['relationships']['maintainer']['data']['id'].to_i).to eq(coffee_shop_maintainer.id)
                expect(json['data']['relationships']['creator']['data']['id'].to_i).to eq(sys_admin.id)
            end
        end
    end

    describe "update" do
        context "when loged in az sys_admin" do
            it "shloud update coffee_shop data and it's owner and maintainer" do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop_maintainer = create :sys_expert
                coffee_shop_owner = create :coffee_owner

                coffee_shop = create :coffee_shop, creator: sys_admin

                put coffee_shop_url(coffee_shop), params: {
                    "coffee_shop":{
                        "name": "new_name",
                        "address": "new_address",
                        "owner_id": coffee_shop_owner.id,
                        "maintainer_id": coffee_shop_maintainer.id
                    }
                }, headers: headers

                expect(json["data"]['attributes']['name']).to include("new_name")
                expect(json["data"]['attributes']['address']).to include("new_address")
                expect(json['data']['relationships']['owner']['data']['id'].to_i).to eq(coffee_shop_owner.id)
                expect(json['data']['relationships']['maintainer']['data']['id'].to_i).to eq(coffee_shop_maintainer.id)
                expect(json['data']['relationships']['creator']['data']['id'].to_i).to eq(sys_admin.id)
            end
        end
    end

    describe "deactivate" do
        context "when loged in az sys_admin" do
            it "shloud deactivate coffee_shop" do
                sys_admin = create :sys_admin
                login sys_admin
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                delete coffee_shop_deactivate_url(coffee_shop), headers: headers

                expect(CoffeeShop.find(coffee_shop.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(coffee_shop.id) 
            end
        end
    end
end
