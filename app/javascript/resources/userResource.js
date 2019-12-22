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
        console.log(user)
        let formData = new FormData();
        formData.append('image', user.image);
        formData.append('user', JSON.stringify({
                email: user.email,
                password: user.password,
                role: user.role
            })
        );

        if(store.state.current_user){
            return apiClient.post("/users",formData,{
                headers: {
                    Authorization: store.state.auth_token,
                    'Content-Type': 'multipart/form-data',
                }
              }
            );
        }
        else{
            return apiClient.post("/users",formData,{
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
              }
            );
        }
    }, //##
    // users#update
    PUT_user(id, user){
        console.log("user")
        
        let formData = new FormData();
        formData.append('image', user.image);
        formData.append('user', JSON.stringify({
                email: user.email,
                password: user.password,
                role: user.role
            })
        );

        return apiClient.put("/users/"+id,formData,
        {
            headers:{
                Authorization: store.state.auth_token,
                'Content-Type': 'multipart/form-data',
            }
        });
    }, //##
    // users#deactivate
    DELETE_user(id){
        console.log("user")
        return apiClient.delete("/users/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }
}