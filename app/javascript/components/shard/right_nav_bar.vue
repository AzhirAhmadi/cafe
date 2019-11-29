<template>
  <el-menu
      default-active="1"
      class="el-menu-vertical"
    >
    <!-- <el-menu-item index="1">
      <i class="el-icon-setting"></i>
        <span>Profile</span>
    </el-menu-item>

    <el-menu-item v-if="current_user" index="1">
      <i class="el-icon-setting"></i>
      <el-button type="success" @click="push_user_edit">Edit</el-button>
    </el-menu-item>

    <el-menu-item v-if="current_user" index="1">
      <i class="el-icon-setting"></i>
      <el-button type="danger" @click="callDEVISE_logout">SingOut</el-button>
    </el-menu-item> -->

    <!-- <el-menu-item index="2">
      <i class="el-icon-setting"></i>
        <span>Management</span>
    </el-menu-item> -->

    <!-- <el-menu-item @click="push_users_index" index="1"> -->
    <el-menu-item @click="push_users_index" v-if="current_user" index="1">
        <i class="el-icon-user"></i>
        <!-- <el-button type="danger" @click="push_users_index">Users</el-button> -->
        Users
    </el-menu-item>

    <el-menu-item @click="push_coffee_shops_index"  index="2">     
    <!-- <el-menu-item @click="push_coffee_shops_index" v-if="current_user" index="2"> -->
        <i class="el-icon-coffee-cup"></i>
        <!-- <el-button type="danger" ></el-button> -->
        CoffeeShops
    </el-menu-item>
  </el-menu>
</template>


<script>
  import route_helper from '../../services/route_helpers'
  import router from '../../packs/router'
  export default {
    data(){
      return {
        current_user: null
      }
    },
    methods: {
      push_users_index(){
        console.log("push_user_update")
        router.push('/users/index');
      },
      push_coffee_shops_index(){
        console.log("push_user_update")
        router.push('/coffee_shops/index');
      },
      push_user_edit(){
        console.log("push_user_update")
        router.push('/users/'+this.current_user.id+'/update');
      },
      callDEVISE_logout(){
        console.log("callDEVISE_logout")
        route_helper.DEVICE().logout()
        .then(response =>{this.$store.dispatch('updateAuthToken', "")})
        .then(response =>{this.$store.dispatch('updateCurrentUser', null)})
      }
    },
    created(){
      this.$store.watch(
        (state, getters) => getters.current_user,
        (newValue, oldValue) => {
          console.log(`Updating from ${oldValue} to ${newValue}`);
          this.current_user = this.$store.state.current_user
        }
      );
      this.current_user = this.$store.state.current_user
    }
  }
</script>