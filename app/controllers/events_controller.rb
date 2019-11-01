class EventsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:show, :index]

    def show
        for_show_prossece_by_current_user_role
    rescue
        render raise ErrorHandling::Errors::Event::DataBaseFind.new          
    end

    def index
        for_index_prossece_by_current_user_role
    end

    def create
        check_create_params

        coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
        event = coffee_shop.created_events.build(event_params)

        authorize event

        if event.save
            render jsonapi: event, include: ['coffee_shop']
        else
            raise ErrorHandling::Errors::Event::DataBaseCreation.new({params: params, event: event})           
        end
    end

    def update
        check_update_params
        
        coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
        event = coffee_shop.created_events.find(params[:id])

        authorize event

        if event.update(event_params)
            render jsonapi: event, include: ['coffee_shop']
        else
            raise ErrorHandling::Errors::Event::DataBaseUpdate.new({params: params,event: event})           
        end
    end

    def deactivate
        coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
        event = coffee_shop.created_events.find(params[:id])

        authorize event

        if event.deleted_at?
            raise ErrorHandling::Errors::Event::DeletedEvent.new({deleted_at: event.deleted_at})          
        end

        event.soft_delete
        render jsonapi: event
    end

    private
        def event_params
            params.require(:event).permit(sanitize_params)
        end

        def check_create_params
            if params[:event].blank? ||
                params[:event][:name].blank? ||
                params[:event][:description].blank? ||
                params[:event][:opens_at].blank? ||
                params[:event][:enrol_start_time].blank? ||
                params[:event][:enrol_end_time].blank? || 
                params[:event][:event_start_time].blank? ||
                params[:event][:event_end_time].blank? || 
                params[:event][:closed_at].blank?
                raise ErrorHandling::Errors::Event::CreationParams.new({params: params})          
            end
        end

        def check_update_params
            if params[:event].blank? ||
                params[:event][:name].blank? ||
                params[:event][:description].blank? ||
                params[:event][:opens_at].blank? ||
                params[:event][:enrol_start_time].blank? ||
                params[:event][:enrol_end_time].blank? || 
                params[:event][:event_start_time].blank? ||
                params[:event][:event_end_time].blank? || 
                params[:event][:closed_at].blank?
                raise ErrorHandling::Errors::Event::UpdateParams.new({params: params})          
            end
        end
        
        def find_coffee_shop
            policy_scope(CoffeeShop).find(params[:coffee_shop_id]) 
        end
        
#for show **********************************************************
        def for_show_prossece_by_current_user_role
            for_show_current_user_is_blank if current_user.blank?
            for_show_current_user_is_player if current_user&.player?
            for_show_current_user_is_sys_expert if current_user&.sys_expert?
            for_show_current_user_is_coffee_owner if current_user&.coffee_owner?
            for_show_current_user_is_sys_admin_or_sys_master if current_user&.sys_admin? || current_user&.sys_master?
        end

        def for_show_current_user_is_blank
        end

        def for_show_current_user_is_player
            event = policy_scope(Event).find(params[:id])
            render jsonapi: event, include: ["coffee_shop"]
        end
        
        def for_show_current_user_is_sys_expert
            coffee_shop = find_coffee_shop
            if coffee_shop.maintainer_id == current_user.id
                event = policy_scope(Event).in_coffee_shop(coffee_shop).find(params[:id])
                render jsonapi: event, include: ["coffee_shop"]
            else
                event = policy_scope(Event).unlocked_events.in_coffee_shop(coffee_shop).find(params[:id])
                render jsonapi: event, include: ["coffee_shop"]
            end
        end

        def for_show_current_user_is_coffee_owner
            coffee_shop = find_coffee_shop
            if coffee_shop.owner_id == current_user.id
                event = policy_scope(Event).in_coffee_shop(coffee_shop).find(params[:id])
                render jsonapi: event, include: ["coffee_shop"]
            else
                event = policy_scope(Event).unlocked_events.in_coffee_shop(coffee_shop).find(params[:id])
                render jsonapi: event, include: ["coffee_shop"]
            end
        end

        def for_show_current_user_is_sys_admin_or_sys_master
            events = policy_scope(Event).in_coffee_shop(find_coffee_shop).find(params[:id])
            render jsonapi: events, include: ["coffee_shop"]
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
        end

        def for_index_current_user_is_player
            events = policy_scope(Event).in_coffee_shop(find_coffee_shop)
            render jsonapi: events, include: ["coffee_shop"]
        end
        
        def for_index_current_user_is_sys_expert
            coffee_shop = find_coffee_shop
            if coffee_shop.maintainer_id == current_user.id
                events = policy_scope(Event).in_coffee_shop(coffee_shop)
                render jsonapi: events, include: ["coffee_shop"]
            else
                events = policy_scope(Event).unlocked_events.in_coffee_shop(coffee_shop)
                render jsonapi: events, include: ["coffee_shop"]
            end
        end

        def for_index_current_user_is_coffee_owner
            coffee_shop = find_coffee_shop
            if coffee_shop.owner_id == current_user.id
                events = policy_scope(Event).in_coffee_shop(coffee_shop)
                render jsonapi: events, include: ["coffee_shop"]
            else
                events = policy_scope(Event).unlocked_events.in_coffee_shop(coffee_shop)
                render jsonapi: events, include: ["coffee_shop"]
            end
        end

        def for_index_current_user_is_sys_admin_or_sys_master
            events = policy_scope(Event).in_coffee_shop(find_coffee_shop)
            render jsonapi: events, include: ["coffee_shop"]
        end
end