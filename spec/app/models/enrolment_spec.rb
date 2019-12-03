require 'rails_helper'

RSpec.describe Enrolment, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      expect(create :enrolment).to be_valid
    end

    it "should validate presence of attributes" do
      enrolment = build :enrolment,table: nil, user: nil

      expect(enrolment).not_to be_valid
      expect(enrolment.errors.messages[:table]).to include("must exist")
      expect(enrolment.errors.messages[:table]).to include("can't be blank")
      expect(enrolment.errors.messages[:user]).to include("must exist")
      expect(enrolment.errors.messages[:user]).to include("can't be blank")
    end

    it "should validate user activeness" do
      user =create :player

      user.deleted_at = Time.current
      expect(user.active?).to eq(false)

      enrolment = build :enrolment, user: user
      expect(enrolment).not_to be_valid
      expect(enrolment.errors.messages[:user]).to include("is not active")
    end

    it "should except methods (:user)" do
      enrolment = create :enrolment
      
      expect(enrolment).to respond_to(:user)
    end

    it "should validate table activeness" do
      table =create :opened_table

      table.deleted_at = Time.current
      expect(table.active?).to eq(false)

      enrolment = build :enrolment, table: table
      expect(enrolment).not_to be_valid
      expect(enrolment.errors.messages[:table]).to include("is not active")
    end

    it "should except methods (:table)" do
      enrolment = create :enrolment
      
      expect(enrolment).to respond_to(:table)
    end

    it "should validate  uniqueness of [:table_id, :user_id, :deleted_at]" do
      enrolment = create :enrolment

      new_enrolment = build :enrolment, table: enrolment.table, user: enrolment.user
      new_enrolment.save

      expect(new_enrolment).not_to be_valid
      expect(new_enrolment.errors.messages[:user_id]).to include("has already been taken")
    end
  end
end
