<template>
  <div> 
    <el-row v-if="SELECT_ROLE" style="text-align: right;">
      <router-link :to="{name: 'user_create'}"><el-button type="primary" >Create User</el-button></router-link>
    </el-row>
    <el-row>
      <table style="width:100%">
        <tr>
          <th style="text-align: center; font-size: 2em;">Players</th>
        </tr>
        <tr>
          <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
            <UserInLIst v-for="(user, index) in players" :user='user' :key='index' v-on:removeFromParent="removeUserFromList"/>
          </table>
        </tr>

        <tr>
          <th style="text-align: center; font-size: 2em;">CoffeeOwners</th>
        </tr>
        <tr>
          <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
            <UserInLIst v-for="(user, index) in coffee_owners" :user='user' :key='index' v-on:removeFromParent="removeUserFromList"/>
          </table>
        </tr>

        <tr>
          <th style="text-align: center; font-size: 2em;">SysExperts</th>
        </tr>
        <tr>
          <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
            <UserInLIst v-for="(user, index) in sys_experts" :user='user' :key='index' v-on:removeFromParent="removeUserFromList"/>
          </table>
        </tr>

        <tr>
          <th style="text-align: center; font-size: 2em;">SysAdmins</th>
        </tr>
        <tr>
          <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
            <UserInLIst v-for="(user, index) in sys_admins" :user='user' :key='index' v-on:removeFromParent="removeUserFromList"/>
          </table>
        </tr>

        <tr>
          <th style="text-align: center; font-size: 2em;">SysMasters</th>
        </tr>
        <tr>
          <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
            <UserInLIst v-for="(user, index) in sys_matsers" :user='user' :key='index' v-on:removeFromParent="removeUserFromList"/>
          </table>
        </tr>
      </table>
    </el-row>
  </div>
</template>

<script>
import UserInLIst from './components/user_in_list.vue'
import route_helpers from '../../services/route_helpers'

export default {
  data(){
    return {
      users: [],
      current_user: null,
    }
  },
  components:{
    UserInLIst
  },
  methods:{
    callUsers(){
      console.log("callUsers")
       route_helpers.GET().users()
       .then(response => {this.users = response.data.data})
    },
    handleClick() {
      console.log('click');
    },
    removeUserFromList(id){
      for(var i = 0; i < this.users.length; i++){ 
        if (this.users[i].id === id) {
          this.users.splice(i, 1); 
        }
      }
    }
  },
  computed:{
    players: function() {
       return this.users.filter(function(user) {
         return user.attributes.role === 'player';
     })
    },
    coffee_owners: function() {
       return this.users.filter(function(user) {
         return user.attributes.role === 'coffee_owner';
     })
    },
    sys_experts: function() {
       return this.users.filter(function(user) {
         return user.attributes.role === 'sys_expert';
     })
    },
    sys_admins: function() {
       return this.users.filter(function(user) {
         return user.attributes.role === 'sys_admin';
     })
    },
    sys_matsers: function() {
       return this.users.filter(function(user) {
         return user.attributes.role === 'sys_master';
     })
    },
    SELECT_ROLE(){
      return this.current_user !== null && this.current_user.attributes.role !== "player"
    }
  },
  created(){
    console.log("users#index.created")
    this.$store.dispatch('updatePageHeader', 'Users List')
    this.$store.watch(
        (state, getters) => getters.current_user,
        (newValue, oldValue) => {
          console.log(`Updating from ${oldValue} to ${newValue}`);
          this.current_user = this.$store.state.current_user
          // this.$forceUpdate();          
        }
      );
      this.current_user = this.$store.state.current_user
    this.callUsers()
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #888;
  text-align: center;
  padding: 8px;
}
</style>
