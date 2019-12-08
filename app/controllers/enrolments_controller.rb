class EnrolmentsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    def index
        enrolments = policy_scope(Enrolment).in_coffee_shop(find_coffee_shop).in_event(find_event).for_table(find_table)
        render jsonapi: enrolments
    rescue
        render jsonapi: []
    end

    def create
        enrolment = current_user.enrolments.build(table_id: params[:table_id])

        authorize enrolment

        if enrolment.save
            render jsonapi: enrolment
        else
            raise ErrorHandling::Errors::Enrolment::DataBaseCreation.new({params: params, enrolment: enrolment})           
        end
    end

    def destroy
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

        def find_coffee_shop
            policy_scope(CoffeeShop).find(params[:coffee_shop_id]) 
        end

        def find_table
            policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event).find(params[:table_id])
        end
#find event by role and ownership
        def find_event
            coffee_shop = find_coffee_shop
            return find_event_for_coffee_owner(coffee_shop) if current_user&.coffee_owner?
            return find_event_for_sys_expert(coffee_shop) if current_user&.sys_expert?
            find_event_for_other(coffee_shop)
        end

        def find_event_for_coffee_owner(coffee_shop)
            return policy_scope(Event).in_coffee_shop(coffee_shop).find(params[:event_id]) if coffee_shop.owner_id == current_user.id
            policy_scope(Event).unlocked_events.in_coffee_shop(coffee_shop).find(params[:event_id])
        end

        def find_event_for_sys_expert(coffee_shop)
            return policy_scope(Event).in_coffee_shop(coffee_shop).find(params[:event_id]) if coffee_shop.maintainer_id == current_user.id
            policy_scope(Event).unlocked_events.in_coffee_shop(coffee_shop).find(params[:event_id])
        end

        def find_event_for_other(coffee_shop)
            policy_scope(Event).in_coffee_shop(coffee_shop).find(params[:event_id])
        end
#end
end