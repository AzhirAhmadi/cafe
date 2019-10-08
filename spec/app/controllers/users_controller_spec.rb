require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe "when there is no 'Authorization' param in header" do
        subject{post :create, params: {}, format: :json}
        it_behaves_like "Authorization_token_absence"
    end
end