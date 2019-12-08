class UsersController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create]

    def show
        user = policy_scope(User).find(params[:id])
        render jsonapi: user
    rescue
        render raise ErrorHandling::Errors::User::DataBaseFind.new          
    end

    def index
        users = policy_scope(User)
        unless(params[:role].blank?)
            users = users.active_users.where(role: params[:role])
        end
        unless(params[:free].blank?)
            users = users.active_users.without_coffee_shop
        end
        render jsonapi: users
    end
    
    def create
        if params[:user].blank? || params[:user][:email].blank? || params[:user][:password].blank? || params[:user][:role].blank?
            raise ErrorHandling::Errors::User::CreationParams.new({params: params})          
        end
        
        user =User.new(user_params)
        authorize user
        if user.save
            render jsonapi: user
        else
            raise ErrorHandling::Errors::User::DataBaseCreation.new({params: params,user: user})          
        end
    end

    def update
        if params[:user].blank?|| params[:user][:email].blank? | params[:user][:password].blank? || params[:user][:role].blank?
            raise ErrorHandling::Errors::User::UpdateParams.new({params: params})          
        end

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
        if user.deleted_at?
            raise ErrorHandling::Errors::User::DeletedUser.new({deleted_at: user.deleted_at})          
        end
        user.soft_delete
        render jsonapi: user
    end

    def profile
        render jsonapi: current_user
    end

    private
        # enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
        def user_params
            params.require(:user).permit(sanitize_params)
        end
end