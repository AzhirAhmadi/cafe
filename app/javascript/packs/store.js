import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state:{
        auth_token: 0,
        current_user: null,
        page_header: 'Home'
    },
    getters: {
        auth_token: state => state.auth_token,
        current_user: state => state.current_user,
        page_header: state => state.page_header
    },
    mutations: {
        SET_AUTH_TOKEN(state, valve){
            state.auth_token = valve
        },
        SET_CURRENT_USER(state, valve){
            state.current_user = valve
        },
        SET_PAGE_HEADER(state, valve){
            state.page_header = valve
        }
    },
    actions: {
        updateAuthToken({ state, commit}, valve){
            console.log("updateAuthToken")
            commit('SET_AUTH_TOKEN', valve)               
        },
        updateCurrentUser({ state, commit}, valve){
            console.log("updateCurrentUser")
            commit('SET_CURRENT_USER', valve)               
        },
        updatePageHeader({ state, commit}, valve){
            console.log("updatePageHeader")
            commit('SET_PAGE_HEADER', valve)               
        }
    }
})