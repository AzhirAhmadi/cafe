require 'rails_helper'

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      expect(build :player).to be_valid
    end

    it "should validate presence of attributes" do
      user = build :player, email: nil, password: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:email]).to include("can't be blank")
      expect(user.errors.messages[:password]).to include("can't be blank")
    end

    it "should validate length of :password (minimum 6)" do
      user = build :player, email: "test@test.com", password: "1"
      expect(user).not_to be_valid
      expect(user.errors.messages[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "should validate :email format (*@*)" do
      user = build :player, email: "invalid", password: "123456"
      expect(user).not_to be_valid
      expect(user.errors.messages[:email]).to include("is invalid")
    end

    it "should validate uniqness of :email" do
      user = build :player, email: "test@test.com", password: "123456"
      user.save
      expect(user.save).to be(true)

      otherUser = build :player, email: "test@test.com", password: "123456"
      expect(otherUser).not_to be_valid
      expect(otherUser.errors.messages[:email]).to include("has already been taken")
    end

    it "should except :roles [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]" do
      expect(User).to respond_to(:sys_master)
      expect(User).to respond_to(:sys_admin)
      expect(User).to respond_to(:sys_expert)
      expect(User).to respond_to(:coffee_owner)
      expect(User).to respond_to(:player)
    end

    it "shuld respond_to method active?" do
      user = create :player
      expect(user).to respond_to(:active?)
      expect(user.active?).to eq(true)
      user.deleted_at = Time.current
      expect(user.active?).to eq(false)
    end

    it "shuld respond_to method enroled_tables" do
      user = create :player
      expect(user).to respond_to(:enroled_tables)
    end
  end
end
