import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'

export default {
    //devise_api/sessions#create
    POST_login(email, password){
        return apiClient.post("/login",{"user": {"email": email, "password": password }});
    },
    // devise_api/sessions#destroy
    DELETE_logout(){
        console.log("logout")
        return apiClient.delete("/logout",{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }
}