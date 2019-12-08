import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'
export default {
    // events#index
    GET_coffee_shop_events(coffee_shop_id){
        console.log("coffee_shop_events")
        if(store.state.current_user){
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events",{
                headers: {
                    Authorization: store.state.auth_token
                }
            });
        }
        else{
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events");
        }
    }, //##
    // events#show
    GET_coffee_shop_event(coffee_shop_id, id){
        console.log("coffee_shop_event")
        if(store.state.current_user){
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+id,{
                headers: {
                Authorization: store.state.auth_token
                }
            });
        }
        else{
            return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+id);
        }
    }, //##
    // events#create
    POST_coffee_shop_events(coffee_shop_id, event){
        console.log("coffee_shop_events")
        return apiClient.post("/coffee_shops/"+coffee_shop_id+"/events",
        {
            "event": {
                name: event.name,
                description: event.description,
                opens_at: event.opens_at,
                enrol_start_time: event.enrol_start_time,
                enrol_end_time: event.enrol_end_time,
                event_start_time: event.event_start_time,
                event_end_time: event.event_end_time,
                closed_at: event.closed_at
            }
        },    
        {
            headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    }, //##
    // events#update
    PUT_coffee_shop_event(coffee_shop_id, id, event){
        console.log("coffee_shop_event")
        return apiClient.put("/coffee_shops/"+coffee_shop_id+"/events/"+id,
        {
            event: {
                name: event.name,
                description: event.description,
                opens_at: event.opens_at,
                enrol_start_time: event.enrol_start_time,
                enrol_end_time: event.enrol_end_time,
                event_start_time: event.event_start_time,
                event_end_time: event.event_end_time,
                closed_at: event.closed_at
            }
        },    
        {
            headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    }, //##
    // events#deactivate
    DELETE_coffee_shop_event(coffee_shop_id, id){
        console.log("coffee_shop_event")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/events/"+id,{
            headers: {
            Authorization: store.state.auth_token
            }
        });
    }, //##
}