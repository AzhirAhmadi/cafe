import apiClient from './apiClient'
import store from '../packs/store'
import error_handler from '../services/error_handler'

export default {
    // coffee_shops#index
    GET_coffee_shops(){
        console.log("coffee_shops")
        return apiClient.get("/coffee_shops",{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }, //##
    // coffee_shops#show
    GET_coffee_shop(id){
        console.log("coffee_shop")
        return apiClient.get("/coffee_shops/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }, //##
    // coffee_shops#create
    POST_coffee_shops(coffee_shop){
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
    }, //##
    // coffee_shops#update
    PUT_coffee_shop(id, coffee_shop){
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
    }, //##
    // coffee_shops#deactivate
    DELETE_coffee_shop(id){
        console.log("coffee_shops")
        return apiClient.delete("/coffee_shops/"+id,{
            headers: {
              Authorization: store.state.auth_token
            }
        });
    }, //##
}