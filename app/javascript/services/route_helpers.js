import axios from 'axios'
import store from '../packs/store'
import error_handler from './error_handler'

const apiClient = axios.create({
    baseURL: 'http://localhost:3000/api',
    withCredentials: false,
    headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
    }
})

class DEVICE {
//Devise ###################################################################################
    // devise_api/sessions#create
    login(email, password){
        return apiClient.post("/login",{"user": {"email": email, "password": password }});
    }

    // devise_api/sessions#destroy
    logout(){
        console.log("logout")
        return apiClient.delete("/logout",{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }
}
class GET{
//GET ##########################################################################################
// board_games#index
    coffee_shop_board_games(coffee_shop_id){
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
    } //##
// board_games#show
    coffee_shop_board_game(coffee_shop_id, id){
        console.log("coffee_shop_board_game")
        return apiClient.get("/coffee_shops/"+coffee_shop_id+"/board_games/"+id);
    } //##
// tables#index
    coffee_shop_event_tables(coffee_shop_id, event_id){
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
    } //##
// tables#show
    coffee_shop_event_table(coffee_shop_id, event_id, id){
        console.log("coffee_shop_event_table")
        return apiClient.get("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+id);
    } //##
// events#index
    coffee_shop_events(coffee_shop_id){
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
    } //##
// events#show
    coffee_shop_event(coffee_shop_id, id){
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
    } //##
// coffee_shops#index
    coffee_shops(){
        console.log("coffee_shops")
        return apiClient.get("/coffee_shops",{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    } //##
// coffee_shops#show
    coffee_shop(id){
        console.log("coffee_shop")
        return apiClient.get("/coffee_shops/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    } //##
// users#index
    users(url_params = ""){
        console.log("users")
        return apiClient.get("/users"+url_params,{
            headers: {
              Authorization: store.state.auth_token
            }
        }).catch(error => {error_handler._401("get#users")})
    } //##
// users#show
    user(id){
        console.log("user")
        return apiClient.get("/users/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    } //##
// users#profile
    profile(){
        console.log("profile")
        return apiClient.get("/profile",{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    } //##
}
class POST{
//POST ##########################################################################################
// board_games#create
    coffee_shop_board_games(coffee_shop_id, board_game){
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
    } //##
// tables#create
    coffee_shop_event_tables(coffee_shop_id, event_id){
        console.log("coffee_shop_event_tables")
        return apiClient.post("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables");
    } //##
// enrolments#create
    coffee_shop_event_enrolments(coffee_shop_id, event_id){
        console.log("coffee_shop_event_enrolments")
        return apiClient.post("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/enrolments");
    } //##
// events#create
    coffee_shop_events(coffee_shop_id, event){
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
    } //##
// coffee_shops#create
    coffee_shops(coffee_shop){
        console.log("coffee_shops")
        return apiClient.post("/coffee_shops",
            {"coffee_shop": {
                    "name": coffee_shop.name,
                    "address": coffee_shop. address,
                    "owner_id": coffee_shop.owner_id,
                    "maintainer_id": coffee_shop.maintainer_id
                }
            },
            {
                headers: {
                    Authorization: store.state.auth_token
                }
            }
        );
    } //##
// users#create
    users(user){
        console.log("users")
        if(store.state.current_user){
            return apiClient.post("/users",
                {"user":
                    {
                        "email": user.email,
                        "password": user.password,
                        "role": user.role
                    }
                },
                {
                    headers: {
                        Authorization: store.state.auth_token
                    }
                }
            );
        }
        else{
            return apiClient.post("/users",
                {"user":
                    {
                        "email": user.email,
                        "password": user.password,
                        "role": user.role
                    }
                }
            );
        }
    } //##
}
class PUT{
//PUT ##########################################################################################
// board_games#update
    coffee_shop_board_game(coffee_shop_id, id, board_game){
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
    } //##
// tables#update
    coffee_shop_event_table(coffee_shop_id, event_id, id){
        console.log("coffee_shop_event_table")
        return apiClient.put("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+id);
    } //##
// events#update
    coffee_shop_event(coffee_shop_id, id, event){
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
    } //##
// coffee_shops#update
    coffee_shop(id, coffee_shop){
        console.log("coffee_shop")
        return apiClient.put("/coffee_shops/"+id,{
            coffee_shop:{
                    name: coffee_shop.name,
                    address: coffee_shop.address,
                    owner_id: coffee_shop.owner_id,
                    maintainer_id: coffee_shop.maintainer_id
                }
            },
            {
            headers:{
                Authorization: store.state.auth_token
            }
        });
    } //##
// users#update
    user(id, user){
        console.log("user")
        // return apiClient.put("/users/"+id);
        return apiClient.put("/users/"+id,{
            user:
                {
                    email: user.email,
                    password: user.password,
                    role: user.role
                }
            },
            {
                headers: {
                Authorization: store.state.auth_token
            }
        });
    } //##
}
class DELETE{
//DELETE ##########################################################################################
// board_games#deactivate
    coffee_shop_board_game_deactivate(coffee_shop_id, id){
        console.log("coffee_shop_board_game_deactivate")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/board_games/"+id);
    } //##
// tables#deactivate
    coffee_shop_event_table_deactivate(coffee_shop_id, event_id, id){
        console.log("coffee_shop_event_table_deactivate")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/tables/"+id);
    } //##
// enrolments#deactivate
    coffee_shop_event_enrolment_deactivate(coffee_shop_id, event_id, id){
        console.log("coffee_shop_event_enrolment_deactivate")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/events/"+event_id+"/enrolments/"+id);
    } //##
// events#deactivate
    coffee_shop_event_deactivate(coffee_shop_id, id){
        console.log("coffee_shop_event_deactivate")
        return apiClient.delete("/coffee_shops/"+coffee_shop_id+"/events/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    } //##
// coffee_shops#deactivate
    coffee_shop_deactivate(id){
        console.log("coffee_shop_deactivate")
        return apiClient.delete("/coffee_shops/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    } //##
// users#deactivate
    user_deactivate(id){
        console.log("user_deactivate")
        return apiClient.delete("/users/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }
}

const insDEVICE = new DEVICE;
const insGET = new GET;
const insPOST = new POST;
const insPUT = new PUT;
const insDELETE = new DELETE;

export default {
    DEVICE(){
        return insDEVICE;
    },
    GET(){
        return insGET;
    },
    POST(){
        return insPOST;
    },
    PUT(){
        return insPUT;
    },
    DELETE(){
        return insDELETE;
    }
}