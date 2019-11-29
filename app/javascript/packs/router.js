
// config router
import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

// import routes
import routes from '../routes'

const router = new VueRouter({
  mode: 'history',
  routes
});

export default router;