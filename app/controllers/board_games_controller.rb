class BoardGamesController < ApplicationController

    def create
        if params[:board_game].blank? ||
            params[:board_game][:name].blank? ||
            params[:board_game][:publisher].blank? ||
            params[:board_game][:min_player].blank? ||
            params[:board_game][:max_player].blank? ||
            params[:board_game][:play_time].blank?
            raise ErrorHandling::Errors::BoardGame::CreationParams.new({params: params})          
        end
        board_game = BoardGame.new(board_game_params)
        board_game.creator_id = params[:coffee_shop_id]
        authorize board_game

        if board_game.save
            render jsonapi: board_game, include: ['creator']
        else
            raise ErrorHandling::Errors::BoardGame::DataBaseCreation.new({params: params,board_game: board_game})           
        end
    end

    def update
        if params[:board_game].blank? ||
            params[:board_game][:name].blank? ||
            params[:board_game][:publisher].blank? ||
            params[:board_game][:min_player].blank? ||
            params[:board_game][:max_player].blank? ||
            params[:board_game][:play_time].blank?
            raise ErrorHandling::Errors::BoardGame::UpdateParams.new({params: params})          
        end
        board_game = BoardGame.find(params[:id])

        authorize board_game

        if board_game.update(board_game_params)
            render jsonapi: board_game, include: ['creator']
        else
            raise ErrorHandling::Errors::BoardGame::DataBaseUpdate.new({params: params,board_game: board_game})           
        end
    end

    def deactivate 
        board_game = BoardGame.find(params[:id])

        authorize board_game

        if board_game.deleted_at?
            raise ErrorHandling::Errors::BoardGame::DeletedCoffeeShop.new({deleted_at: board_game.deleted_at})          
        end

        board_game.soft_delete
        render jsonapi: board_game
    end

    private
        def board_game_params
            params.require(:board_game).permit(sanitize_params)
        end
end