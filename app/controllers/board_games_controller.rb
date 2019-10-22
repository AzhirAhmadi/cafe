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

        authorize board_game
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
        board_game = BoardGame.find(params[:coffee_shop_id])

        authorize board_game
    end

    def deactivate 
        board_game = BoardGame.find(params[:coffee_shop_id])

        authorize board_game
    end

    private
        def board_game_params
            params.require(:board_game).permit(sanitize_params)
        end
end