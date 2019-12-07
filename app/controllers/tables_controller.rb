class TablesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:show, :index]

    def show
        for_show_prossece_by_current_user_role
    rescue
        render raise ErrorHandling::Errors::Table::DataBaseFind.new          
    end

    def index
        for_index_prossece_by_current_user_role
    rescue
        render jsonapi: []
    end

    def create
        check_create_params
        event = find_event 
        
        raise ErrorHandling::Errors::Table::StartedEvent.new() if event.started_event?
        
        table = event.created_tables.build(table_params)

        authorize table

        if table.save
            render jsonapi: table, include: ['event', 'board_game']
        else
            raise ErrorHandling::Errors::Table::DataBaseCreation.new({params: params, table: table})           
        end
    end

    def update
        check_update_params

        event = find_event 
        raise ErrorHandling::Errors::Table::StartedEvent.new() if event.started_event?
        
        table = find_table

        authorize table

        if table.update(table_params)
            render jsonapi: table, include: ['event', 'board_game']
        else
            raise ErrorHandling::Errors::Table::DataBaseUpdate.new({params: params, table: table})           
        end
    end

    def deactivate
        event = find_event 
        raise ErrorHandling::Errors::Table::StartedEvent.new() if event.started_event?
        
        table = find_table

        authorize table
        raise ErrorHandling::Errors::Table::Deletedtable.new({deleted_at: table.deleted_at}) if table.deleted_at?

        table.soft_delete
        render jsonapi: table
    end

    private
        def table_params
            params.require(:table).permit(sanitize_params)
        end

        def check_create_params
            if params[:table].blank?||
                params[:table][:capacity].blank? || params[:table][:table_code].blank? || params[:table][:board_game_id].blank?
                raise ErrorHandling::Errors::Table::CreationParams.new({params: params})          
            end
        end

        def check_update_params
            if params[:table].blank?||
                params[:table][:capacity].blank? || params[:table][:table_code].blank? || params[:table][:board_game_id].blank?
                raise ErrorHandling::Errors::Table::UpdateParams.new({params: params})          
            end
        end
        
        def find_coffee_shop
            policy_scope(CoffeeShop).find(params[:coffee_shop_id]) 
        end

        def find_table
            policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event).find(params[:id])
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

#for show **********************************************************
        def for_show_prossece_by_current_user_role
            for_show_current_user_is_blank if current_user.blank?
            for_show_current_user_is_player if current_user&.player?
            for_show_current_user_is_sys_expert if current_user&.sys_expert?
            for_show_current_user_is_coffee_owner if current_user&.coffee_owner?
            for_show_current_user_is_sys_admin_or_sys_master if current_user&.sys_admin? || current_user&.sys_master?
        end

        def for_show_current_user_is_blank
            render jsonapi: find_table, include: ['event', 'board_game' ]
        end

        def for_show_current_user_is_player
            table = policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event).find(params[:id])
            render jsonapi: table, include: ['event', 'board_game' ]
        end
        
        def for_show_current_user_is_sys_expert
            coffee_shop = find_coffee_shop
            event = find_event
            if coffee_shop.maintainer_id == current_user.id
                table = policy_scope(Table).in_coffee_shop(coffee_shop).in_event(event).find(params[:id])
                render jsonapi: table, include: ['event', 'board_game']
            else
                table = policy_scope(Table).unlocked_tables.in_coffee_shop(coffee_shop).in_event(event).find(params[:id])
                render jsonapi: table, include: ['event', 'board_game']
            end
        end

        def for_show_current_user_is_coffee_owner
            coffee_shop = find_coffee_shop
            event = find_event
            if coffee_shop.owner_id == current_user.id
                table = policy_scope(Table).in_coffee_shop(coffee_shop).in_event(event).find(params[:id])
                render jsonapi: table, include: ['event', 'board_game']
            else
                table = policy_scope(Table).unlocked_tables.in_coffee_shop(coffee_shop).in_event(event).find(params[:id])
                render jsonapi: table, include: ['event', 'board_game']
            end
        end

        def for_show_current_user_is_sys_admin_or_sys_master
            table = policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event).find(params[:id])
            render jsonapi: table, include: ['event', 'board_game']
        end
#end
#for index *********************************************************
        def for_index_prossece_by_current_user_role
            for_index_current_user_is_blank if current_user.blank?
            for_index_current_user_is_player if current_user&.player?
            for_index_current_user_is_sys_expert if current_user&.sys_expert?
            for_index_current_user_is_coffee_owner if current_user&.coffee_owner?
            for_index_current_user_is_sys_admin_or_sys_master if current_user&.sys_admin? || current_user&.sys_master?
        end

        def for_index_current_user_is_blank
            tables = policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event)
            render jsonapi: tables, include: ['event', 'board_game' ]
        end

        def for_index_current_user_is_player
            tables = policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event)
            render jsonapi: tables, include: ['event', 'board_game' ]
        end
        
        def for_index_current_user_is_sys_expert
            coffee_shop = find_coffee_shop
            event = find_event
            if coffee_shop.maintainer_id == current_user.id
                tables = policy_scope(Table).in_coffee_shop(coffee_shop).in_event(event)
                render jsonapi: tables, include: ['event', 'board_game']
            else
                tables = policy_scope(Table).unlocked_tables.in_coffee_shop(coffee_shop).in_event(event)
                render jsonapi: tables, include: ['event', 'board_game']
            end
        end

        def for_index_current_user_is_coffee_owner
            coffee_shop = find_coffee_shop
            event = find_event
            if coffee_shop.owner_id == current_user.id
                tables = policy_scope(Table).in_coffee_shop(coffee_shop).in_event(event)
                render jsonapi: tables, include: ['event', 'board_game']
            else
                tables = policy_scope(Table).unlocked_tables.in_coffee_shop(coffee_shop).in_event(event)
                render jsonapi: tables, include: ['event', 'board_game']
            end
        end

        def for_index_current_user_is_sys_admin_or_sys_master
            tables = policy_scope(Table).in_coffee_shop(find_coffee_shop).in_event(find_event)
            render jsonapi: tables, include: ['event', 'board_game']
        end
#end
end