//import vue
import Vue from 'vue/dist/vue.esm'

//import router
import router from './router'

//import components
import Home from '../views/home.vue'

//import elemnt
import ElementUI from 'element-ui'
import locale from 'element-ui/lib/locale/lang/en'
import 'element-ui/lib/theme-chalk/index.css'
Vue.use(ElementUI, {locale})

//import axios from ‘axios
import axios from 'axios'
import VueAxios from 'vue-axios'
Vue.use(VueAxios, axios)

//import vuex
import Vuex from 'vuex'
Vue.use(Vuex)
import store from './store.js'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    store,
    render: h => h(Home),
    el: '#app',
    components: {
      Home
    }
  }).$mount()
  document.body.appendChild(app.$el)
  // document.getElementsByClassName("el-select-dropdown__empty").innerHTML = "Emptty"
})