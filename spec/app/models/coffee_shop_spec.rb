require 'rails_helper'

RSpec.describe CoffeeShop, type: :model do
  # it "should create coffee_shop" do
  #   creator = create :player
  #   owner = create :player
  #   cafe = CoffeeShop.create(name: "name",address: "address", owner_id:owner.id, creator_id: creator.id)
  #   expect(CoffeeShop).to respond_to(:owner)
  #   expect(CoffeeShop).to respond_to(:creator)
  # end

  describe "#validations" do
    it "shuold have valid factory" do
      expect(create :coffee_shop).to be_valid
    end

    it "should validate presence of attributes" do
        coffee_shop = build :coffee_shop, name: nil, address: nil, owner_id: nil, creator_id: nil
        expect(coffee_shop).not_to be_valid
        expect(coffee_shop.errors.messages[:creator]).to include("must exist")
        expect(coffee_shop.errors.messages[:owner]).to include("must exist")
        expect(coffee_shop.errors.messages[:name]).to include("can't be blank")
        expect(coffee_shop.errors.messages[:address]).to include("can't be blank")
        expect(coffee_shop.errors.messages[:owner_id]).to include("can't be blank")
        expect(coffee_shop.errors.messages[:creator_id]).to include("can't be blank")
        
    end

    it "should validate  uniqueness: { case_sensitive: false } of :name" do
      coffee_shop1 = create :coffee_shop, name: "Name"
      coffee_shop2 = build :coffee_shop, name: "Name"

      expect(coffee_shop2).not_to be_valid
      expect(coffee_shop2.errors.messages[:name]).to include("has already been taken")
    end

    it "should validate  uniqueness: { case_sensitive: false } of :owner_id" do
      owner = create :cafe_owner
      coffee_shop1 = create :coffee_shop, owner: owner 
      coffee_shop2 = build :coffee_shop, owner: owner
      

      expect(coffee_shop2).not_to be_valid
      expect(coffee_shop2.errors.messages[:owner_id]).to include("has already been taken")
    end

    it "should validate owner and creator activeness" do
      owner = create :cafe_owner
      creator =create :sys_admin

      owner.deleted_at = Time.current
      expect(owner.active?).to eq(false)

      creator.deleted_at = Time.current
      expect(creator.active?).to eq(false)

      coffee_shop = build :coffee_shop, owner: owner, creator: creator
      expect(coffee_shop).not_to be_valid
      expect(coffee_shop.errors.messages[:creator]).to include("is not active")
      expect(coffee_shop.errors.messages[:owner]).to include("is not active")
    end

    it "should except methods (:owner, :creator)" do
      coffee_shop = create :coffee_shop
      
      expect(coffee_shop).to respond_to(:owner)
      expect(coffee_shop).to respond_to(:creator)
    end
  end
end