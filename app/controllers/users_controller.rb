class UsersController < ApplicationController
    def create
        
        user =User.create(user_params)
        authorize user
        
        if user.save
            render jsonapi: user
        else
            raise MyError::User::DataBaseCreation.new({params: params,user: user})          
        end
    end
    def profile
        render jsonapi: current_user
    end

    private
        # enum role: [:sys_master, :sys_admin, :sys_expert, :cafe_owner,:player]
        def user_params
            # if current_user.blank? || current_user.player? || current_user.cafe_owner?
            #     return params.require(:user).permit(:email,:password)
            # elsif current_user.sys_expert?
            #     set_params_as_sys_expert params.require(:user).permit(:email,:password, :role)
            # end
            params.require(:user).permit(:email,:password,:role)
        end

        # def set_params_as_sys_expert(result)
        #     if result[:role] == "player" || result[:role] == "cafe_owner"
        #         return result
        #     else 
        #         result[:role] = "player"
        #         return result
        #     end
        # end
end