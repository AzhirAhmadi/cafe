class EventsController < ApplicationController
    def create
        check_create_params
    end

    def update
        check_update_params
    end

    def deactivate

    end

    private
        def check_create_params
            if params[:event].blank? ||
                params[:event][:name].blank? ||
                params[:event][:description].blank? ||
                params[:event][:opens_at].blank? ||
                params[:event][:enrol_start_time].blank? ||
                params[:event][:enrol_end_time].blank? || 
                params[:event][:event_start_time].blank? ||
                params[:event][:event_end_time].blank? || 
                params[:event][:close_at].blank?
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
                params[:event][:close_at].blank?
                raise ErrorHandling::Errors::Event::UpdateParams.new({params: params})          
            end
        end
end