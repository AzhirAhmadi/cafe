class UsersController < ApplicationController
    def create
        
        user =User.create(user_params)
        authorize user
        
        if user.save
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
            params.require(:user).permit(:email,:password,:role)
        end
end