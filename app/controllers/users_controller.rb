class UsersController < ApplicationController

    def create

    end

    def profile
        render jsonapi: @current_user
    end
end