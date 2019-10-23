require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      expect(create :event).to be_valid
    end

    it "should validate presence of attributes" do
      event = build :event, name: nil, description: nil, opens_at: nil,
      enrol_start_time: nil, enrol_end_time: nil, event_start_time: nil,
      event_end_time: nil, closed_at: nil , coffee_shop: nil

      expect(event).not_to be_valid
      expect(event.errors.messages[:coffee_shop]).to include("must exist")
      expect(event.errors.messages[:coffee_shop]).to include("can't be blank")
      expect(event.errors.messages[:name]).to include("can't be blank")
      expect(event.errors.messages[:description]).to include("can't be blank")
      expect(event.errors.messages[:opens_at]).to include("can't be blank")
      expect(event.errors.messages[:enrol_start_time]).to include("can't be blank")
      expect(event.errors.messages[:enrol_end_time]).to include("can't be blank")
      expect(event.errors.messages[:event_start_time]).to include("can't be blank")
      expect(event.errors.messages[:event_end_time]).to include("can't be blank")
      expect(event.errors.messages[:closed_at]).to include("can't be blank")
    end

    it "should validate coffee_shop activeness" do
      coffee_shop =create :coffee_shop

      coffee_shop.deleted_at = Time.current
      expect(coffee_shop.active?).to eq(false)

      event = build :event, coffee_shop: coffee_shop
      expect(event).not_to be_valid
      expect(event.errors.messages[:coffee_shop]).to include("is not active")
    end

    it "should except methods (:coffee_shop)" do
      event = create :event
      
      expect(event).to respond_to(:coffee_shop)
    end

    it "should has correct time table" do
      event = build :event,
      opens_at: Time.now + 10.hours,
      enrol_start_time: Time.now + 9.hours,
      enrol_end_time: Time.now + 8.hours,
      event_start_time: Time.now + 7.hours,
      event_end_time: Time.now + 6.hours,
      closed_at: Time.now + 5.hours
      
      expect(event).not_to be_valid
      expect(event.errors.messages[:opens_at]).to include("time is not correct")
      expect(event.errors.messages[:enrol_start_time]).to include("time is not correct")
      expect(event.errors.messages[:enrol_end_time]).to include("time is not correct")
      expect(event.errors.messages[:event_start_time]).to include("time is not correct")
      expect(event.errors.messages[:event_end_time]).to include("time is not correct")
    end
  end
end