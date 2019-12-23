class BoardGamesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:show, :index]
    
    def show
        board_game = policy_scope(BoardGame).in_coffee_shop(find_coffee_shop).find(params[:id])
        render jsonapi: board_game, include: ['coffee_shop']
    rescue
        render raise ErrorHandling::Errors::BoardGame::DataBaseFind.new          
    end

    def index
        board_games = policy_scope(BoardGame).in_coffee_shop(find_coffee_shop)
        render jsonapi: board_games
    end

    def create
        clear_json_params
        if params[:board_game].blank? ||
            params[:board_game][:name].blank? ||
            params[:board_game][:publisher].blank? ||
            params[:board_game][:min_player].blank? ||
            params[:board_game][:max_player].blank? ||
            params[:board_game][:play_time].blank?
            raise ErrorHandling::Errors::BoardGame::CreationParams.new({params: params})          
        end
        
        coffee_Shop = CoffeeShop.find(params[:coffee_shop_id])
        board_game = coffee_Shop.created_board_games.build(board_game_params)
        authorize board_game
        if board_game.save
            Image.create(image: params[:image], parent: board_game)
            render jsonapi: board_game, include: ['coffee_shop']
        else
            raise ErrorHandling::Errors::BoardGame::DataBaseCreation.new({params: params,board_game: board_game})           
        end
    end

    def update
        clear_json_params
        if params[:board_game].blank? ||
            params[:board_game][:name].blank? ||
            params[:board_game][:publisher].blank? ||
            params[:board_game][:min_player].blank? ||
            params[:board_game][:max_player].blank? ||
            params[:board_game][:play_time].blank?
            raise ErrorHandling::Errors::BoardGame::UpdateParams.new({params: params})          
        end
        coffee_Shop = CoffeeShop.find(params[:coffee_shop_id])
        board_game = coffee_Shop.created_board_games.find(params[:id])

        authorize board_game

        if board_game.update(board_game_params)
            unless(params[:image] == "undefined")
                board_game.avatar.destroy if board_game.avatar
                Image.create(image: params[:image], parent: board_game)
            end
            render jsonapi: board_game, include: ['coffee_shop']
        else
            raise ErrorHandling::Errors::BoardGame::DataBaseUpdate.new({params: params,board_game: board_game})           
        end
    end

    def destroy 
        coffee_Shop = CoffeeShop.find(params[:coffee_shop_id])
        board_game = coffee_Shop.created_board_games.find(params[:id])

        authorize board_game

        if board_game.deleted_at?
            raise ErrorHandling::Errors::BoardGame::DeletedBoardGame.new({deleted_at: board_game.deleted_at})          
        end

        board_game.soft_delete
        render jsonapi: board_game
    end

    private
        def board_game_params
            params.require(:board_game).permit(sanitize_params)
        end

        def find_coffee_shop
            policy_scope(CoffeeShop).find(params[:coffee_shop_id]) 
        end

        def clear_json_params
            params[:board_game]=ActiveSupport::JSON.decode(params[:board_game])
        end
end