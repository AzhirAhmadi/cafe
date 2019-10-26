class EventsController < ApplicationController
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
end