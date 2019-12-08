import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'

export default {
    // board_games#index
    GET_coffee_shop_board_games(coffee_shop_id){
        console.log("coffee_shop_board_games")
        if(store.state.current_user){
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/board_games",{
                headers: {
                Authorization: store.state.auth_token
                }
            });
        }
        else{
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/board_games");
        }
    }, //##
    // board_games#show
    GET_coffee_shop_board_game(coffee_shop_id, id){
        console.log("coffee_shop_board_game")
        return apiClient.get("/coffee_shops/"+coffee_shop_id+"/board_games/"+id);
    }, //##
    // board_games#create
    POST_coffee_shop_board_games(coffee_shop_id, board_game){
        console.log("coffee_shop_board_games")
        return apiClient.post("/coffee_shops/"+coffee_shop_id+"/board_games",{
            board_game: {
                name: board_game.name,
                publisher: board_game.publisher,
                min_player: board_game.min_player,
                max_player: board_game.max_player,
                play_time: board_game.play_time,
                description: board_game.description,
            }
        },
        {
            headers: {
                Authorization: store.state.auth_token
            }
        });
    }, //##
    // board_games#update
    PUT_coffee_shop_board_game(coffee_shop_id, id, board_game){
        console.log("coffee_shop_board_game")
        return apiClient.put("/coffee_shops/"+coffee_shop_id+"/board_games/"+id,
        {
            board_game: {
                name: board_game.name,
                publisher: board_game.publisher,
                description: board_game.description,
                min_player: board_game.min_player,
                max_player: board_game.max_player,
                play_time: board_game.play_time,
            }
        },    
        {
            headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    }, //##
    // board_games#deactivate
    DELETE_coffee_shop_board_game(coffee_shop_id, id){
        console.log("coffee_shop_board_game")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/board_games/"+id,{
            headers: {
            Authorization: store.state.auth_token
            }
        });
    }, //##
}