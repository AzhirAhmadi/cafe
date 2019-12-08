import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'

export default {
    // tables#index
    GET_coffee_shop_event_tables(coffee_shop_id, event_id){
        console.log("coffee_shop_event_tables")
        if(store.state.current_user){
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables",{
                headers: {
                    Authorization: store.state.auth_token
                }
            });
        }
        else{
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables");
        }
    }, //##
    // tables#show
    GET_coffee_shop_event_table(coffee_shop_id, event_id, id){
        console.log("coffee_shop_event_table")
        return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+id);
    }, //##
    // tables#create
    POST_coffee_shop_event_tables(coffee_shop_id, event_id, table){
        console.log("coffee_shop_event_tables")
        return apiClient.post("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables",
        {
            table: {
                capacity: table.capacity,
                table_code: table.table_code,
                board_game_id: table.board_game_id,
            },
        },    
        {
            headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    }, //##
    // tables#update
    PUT_coffee_shop_event_table(coffee_shop_id, event_id, id, table){
        console.log("coffee_shop_event_table")
        return apiClient.put("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+id,
        {
            table: {
                capacity: table.capacity,
                table_code: table.table_code,
                board_game_id: table.board_game_id,
            },
        },    
        {
            headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    }, //##
    // tables#deactivate
    DELETE_coffee_shop_event_table_deactivate(coffee_shop_id, event_id, id){
        console.log("coffee_shop_event_table_deactivate")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+id,{
            headers: {
            Authorization: store.state.auth_token
            }
        });
    }, //##
}