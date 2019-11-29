class EnrolmentsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    def create
        check_create_params

        enrolment = current_user.enrolments.build(enrolment_params)

        authorize enrolment

        if enrolment.save
            render jsonapi: enrolment, include: ['coffee_shop']
        else
            raise ErrorHandling::Errors::Enrolment::DataBaseCreation.new({params: params, enrolment: enrolment})           
        end
    end

    def deactivate
        enrolment = Enrolment.find(params[:id])

        authorize enrolment

        if enrolment.deleted_at?
            raise ErrorHandling::Errors::Enrolment::Deletedenrolment.new({deleted_at: enrolment.deleted_at})          
        end

        enrolment.soft_delete
        render jsonapi: enrolment
    end

    private
        def enrolment_params
            params.require(:enrolment).permit(sanitize_params)
        end

        def check_create_params
            if params[:enrolment].blank? ||
                params[:enrolment][:table_id].blank?
                raise ErrorHandling::Errors::Enrolment::CreationParams.new({params: params})          
            end
        end

        def check_update_params
            if params[:enrolment].blank? ||
                params[:enrolment][:name].blank? ||
                params[:enrolment][:description].blank? ||
                params[:enrolment][:opens_at].blank? ||
                params[:enrolment][:enrol_start_time].blank? ||
                params[:enrolment][:enrol_end_time].blank? || 
                params[:enrolment][:enrolment_start_time].blank? ||
                params[:enrolment][:enrolment_end_time].blank? || 
                params[:enrolment][:closed_at].blank?
                raise ErrorHandling::Errors::Enrolment::UpdateParams.new({params: params})          
            end
        end
        
        def find_coffee_shop
            policy_scope(CoffeeShop).find(params[:coffee_shop_id]) 
        end

#for index *********************************************************
        def for_index_prossece_by_current_user_role
            for_index_current_user_is_blank if current_user.blank?
            for_index_current_user_is_player if current_user&.player?
            for_index_current_user_is_sys_expert if current_user&.sys_expert?
            for_index_current_user_is_coffee_owner if current_user&.coffee_owner?
            for_index_current_user_is_sys_admin_or_sys_master if current_user&.sys_admin? || current_user&.sys_master?
        end

        def for_index_current_user_is_blank
            # enrolments = policy_scope(enrolment).in_coffee_shop(find_coffee_shop)
            # render jsonapi: enrolments, include: ["coffee_shop"]
        end

        def for_index_current_user_is_player
            # enrolments = policy_scope(enrolment).in_coffee_shop(find_coffee_shop)
            # render jsonapi: enrolments, include: ["coffee_shop"]
        end
        
        def for_index_current_user_is_sys_expert
            # coffee_shop = find_coffee_shop
            # if coffee_shop.maintainer_id == current_user.id
            #     enrolments = policy_scope(enrolment).in_coffee_shop(coffee_shop)
            #     render jsonapi: enrolments, include: ["coffee_shop"]
            # else
            #     enrolments = policy_scope(enrolment).unlocked_enrolments.in_coffee_shop(coffee_shop)
            #     render jsonapi: enrolments, include: ["coffee_shop"]
            # end
        end

        def for_index_current_user_is_coffee_owner
            # coffee_shop = find_coffee_shop
            # if coffee_shop.owner_id == current_user.id
            #     enrolments = policy_scope(enrolment).in_coffee_shop(coffee_shop)
            #     render jsonapi: enrolments, include: ["coffee_shop"]
            # else
            #     enrolments = policy_scope(enrolment).unlocked_enrolments.in_coffee_shop(coffee_shop)
            #     render jsonapi: enrolments, include: ["coffee_shop"]
            # end
        end

        def for_index_current_user_is_sys_admin_or_sys_master
            # enrolments = policy_scope(enrolment).in_coffee_shop(find_coffee_shop)
            # render jsonapi: enrolments, include: ["coffee_shop"]
        end
end