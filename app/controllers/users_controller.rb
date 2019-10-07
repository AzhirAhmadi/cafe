class UsersController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create]
    def create
        user =User.create(permitted_attributes)
        puts user_params
        authorize user
        
        if user.save
            render jsonapi: user
        else
            raise ErrorHandling::Errors::User::DataBaseCreation.new({params: params,user: user})          
        end
    end

    def update
        user = User.find(params[:id])
        authorize user
        if user.update(user_params)
            render jsonapi: user
        else
            raise ErrorHandling::Errors::User::DataBaseCreation.new({params: params,user: user})          
        end
    end

    def destroy
        user = User.find(params[:id])
        authorize user
        if user.destroy
            render jsonapi: user
        else
            raise ErrorHandling::Errors::User::DataBaseCreation.new({params: params,user: user})          
        end
    end

    def profile
        render jsonapi: current_user
    end

    private
        # enum role: [:sys_master, :sys_admin, :sys_expert, :cafe_owner,:player]
        def user_params
            params.require(:user).permit(sanitize_params)
        end
end