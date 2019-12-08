import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'

export default {
    // enrolments#index
    GET_coffee_shop_event_table_enrolments(coffee_shop_id, event_id, table_id, url_params = ""){
        console.log("coffee_shop_event_table_enrolments")
        if(store.state.current_user){
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+table_id+"/enrolments"+url_params,{
                headers: {
                Authorization: store.state.auth_token
                }
            });
        }
        else{
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+table_id+"/enrolments"+url_params);
        }
    }, //##
    // enrolments#create
    POST_coffee_shop_event_table_enrolments(coffee_shop_id, event_id, table_id){
        console.log("coffee_shop_event_table_enrolments")
        
        return apiClient.post("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+table_id+"/enrolments",
        {},    
        {
            headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    }, //##
    // enrolments#deactivate
    DELETE_coffee_shop_event_table_enrolment_deactivate(coffee_shop_id, event_id, table_id, id){
        console.log("coffee_shop_event_table_enrolment_deactivate")
        
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+table_id+"/enrolments/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }, //##
}