class UsersController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create]
    def create
        user =User.create(user_params)
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

    def deactivate
        puts params
        user = User.find(params[:user_id])
        authorize user

        if user.deleted_at?
            raise ErrorHandling::Errors::User::DeletedUser.new({deleted_at: user.deleted_at})          
        end
        
        if user.soft_delete
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