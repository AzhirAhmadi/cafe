require 'rails_helper'

RSpec.describe Image, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      user = create(:player)
      image = build(:picture, parent: user, image: nil)
      expect(image).to be_valid
    end
  end
end