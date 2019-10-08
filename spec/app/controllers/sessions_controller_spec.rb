require 'rails_helper'

RSpec.describe DeviseApi::SessionsController, type: :controller do
    describe "login" do
        it "login by player role" do
            user  = create(:player)
            

            response = sing_in user
            body = response.body
            puts body
        end
    end
end