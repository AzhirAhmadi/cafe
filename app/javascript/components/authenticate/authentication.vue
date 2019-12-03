<template>
    <div id="content">
      <div v-if="current_user">
        <UserIcon :user="current_user"/>
      </div>
      <div v-else>
        <router-link :to="{name: 'sing_in'}"><el-button type="success" >SingIn</el-button></router-link>
        <router-link :to="{name: 'user_create'}"><el-button type="primary" >SingUp</el-button></router-link>
      </div>
    </div>
</template>


<script>
  import UserIcon from "../users/components/user_icon"
  import route_helper from '../../services/route_helpers'
  export default {
    data(){
      return {
        current_user: null
      }
    },
    components:{
      UserIcon
    },
    methods:{
      callDEVISE_logout(){
        console.log("callDEVISE_logout")
        route_helper.DEVICE().logout()
        .then(response =>{this.$store.dispatch('updateAuthToken', "")})
        .then(response =>{this.$store.dispatch('updateCurrentUser', null)})
      }
    },
    created(){
      // this.$store.watch(
      //   (state, getters) => getters.auth_token,
      //   (newValue, oldValue) => {
      //     this.auth_token = this.$store.state.auth_token
      //   }
      // );
      this.$store.watch(
        (state, getters) => getters.current_user,
        (newValue, oldValue) => {
          console.log(`Updating from ${oldValue} to ${newValue}`);
          this.current_user = this.$store.state.current_user
          // this.$forceUpdate();          
        }
      );
    }
  }
</script>
<style scoped>
#logout{
    width: 10px;
    height: 10px;
    border-radius: 50%;
}
</style>