class CoffeeShopsController < ApplicationController

    def create
        if params[:coffee_shop].blank? || params[:coffee_shop][:name].blank? ||
            params[:coffee_shop][:address].blank? || params[:coffee_shop][:owner_id].blank?
            raise ErrorHandling::Errors::CoffeeShop::CreationParams.new({params: params})          
        end
    end

    def update
        if params[:coffee_shop].blank? || params[:coffee_shop][:name].blank? || 
            params[:coffee_shop][:address].blank? || params[:coffee_shop][:owner_id].blank?
            raise ErrorHandling::Errors::CoffeeShop::UpdateParams.new({params: params})
        end
    end
end