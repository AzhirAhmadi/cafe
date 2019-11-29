class CoffeeShopsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:show, :index]

    def show
        coffee_shop = policy_scope(CoffeeShop).find(params[:id])
        render jsonapi: coffee_shop, include: ["owner", "maintainer"]
    rescue
        render raise ErrorHandling::Errors::CoffeeShop::DataBaseFind.new          
    end

    def index
        coffee_shops = policy_scope(CoffeeShop)
        # unless(params[:role].blank?)
        #     users = users.where(role: params[:role])
        # end
        # unless(params[:free].blank?)
        #     users = users.has_no_coffee_shop
        # end
        render jsonapi: coffee_shops, include: ["owner", "maintainer"]
    end

    def create
        if params[:coffee_shop].blank? || params[:coffee_shop][:name].blank? ||
            params[:coffee_shop][:address].blank? || params[:coffee_shop][:owner_id].blank?
            raise ErrorHandling::Errors::CoffeeShop::CreationParams.new({params: params})          
        end
        coffee_shop = current_user.created_coffee_shop.build(coffee_shop_params)

        authorize coffee_shop

        if coffee_shop.save
            render jsonapi: coffee_shop, include: ['owner', 'creator', 'maintainer']
        else
            raise ErrorHandling::Errors::CoffeeShop::DataBaseCreation.new({params: params,coffee_shop: coffee_shop})          
        end
    end

    def update
        if params[:coffee_shop].blank? || params[:coffee_shop][:name].blank? || 
            params[:coffee_shop][:address].blank? || params[:coffee_shop][:owner_id].blank? ||
            params[:coffee_shop][:maintainer_id].blank? 
            raise ErrorHandling::Errors::CoffeeShop::UpdateParams.new({params: params})
        end

        coffee_shop = CoffeeShop.find(params[:id])
        authorize coffee_shop

        coffee_shop.update(coffee_shop_params)
        
        if coffee_shop.save
            render jsonapi: coffee_shop, include: ['owner', 'creator', 'maintainer']
        else
            raise ErrorHandling::Errors::User::DataBaseCreation.new({params: params,coffee_shop: coffee_shop})
        end
    end

    def deactivate
        coffee_shop = CoffeeShop.find(params[:id])
        authorize coffee_shop
        if coffee_shop.deleted_at?
            raise ErrorHandling::Errors::CoffeeShop::DeletedCoffeeShop.new({deleted_at: coffee_shop.deleted_at})          
        end

        coffee_shop.soft_delete
        render jsonapi: coffee_shop
    end

    private
        def coffee_shop_params
            params.require(:coffee_shop).permit(sanitize_params)
        end
end