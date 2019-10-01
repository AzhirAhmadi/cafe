class UsersController < ApplicationController

    def create

    end

    def profile
        render json: @current_user
    end
end