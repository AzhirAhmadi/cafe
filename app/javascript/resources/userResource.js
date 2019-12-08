import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'

export default {
    // users#index
    GET_users(url_params = ""){
        console.log("users")
        return apiClient.get("/users"+url_params,{
            headers: {
              Authorization: store.state.auth_token
            }
        }).catch(error => {error_handler._401("get#users")})
    }, //##
    // users#show
    GET_user(id){
        console.log("user")
        return apiClient.get("/users/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }, //##
    // users#profile
    GET_profile(){
        console.log("profile")
        return apiClient.get("/profile",{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }, //##
    // users#create
    POST_users(user){
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
    }, //##
    // users#update
    PUT_user(id, user){
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
    }, //##
    // users#deactivate
    DELETE_user_deactivate(id){
        console.log("user_deactivate")
        return apiClient.delete("/users/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }
}