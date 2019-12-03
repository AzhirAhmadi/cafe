<template>
  <el-row>
    <el-col :span="20" >
        <!-- <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal">
          <el-menu-item>{{page_header}}</el-menu-item>

          <el-menu-item index="1"><router-link :to="{name: 'user_index'}"><div>Users</div></router-link></el-menu-item>
          <el-menu-item index="2"><router-link :to="{name: 'coffee_shop_index'}"><div>CoffeeShops</div></router-link></el-menu-item>

        </el-menu> -->

        <el-page-header @back="goBack" :content='page_header'>
        </el-page-header>
    </el-col>
    <el-col :span="4">
        <Authentication></Authentication>
    </el-col>
  </el-row>
</template>

<script>
  import Authentication from '../authenticate/authentication.vue'
  import route_helper from '../../services/route_helpers'
  export default {
    components:{
      Authentication
    },
    data() {
      return {
        activeIndex: '2',
        page_header: 'Home'
      };
    },
    methods:{
      goBack() {
        console.log('go back');
        this.$router.go(-1)
      }
    },
    created(){
      this.$store.watch(
        (state, getters) => getters.page_header,
        (newValue, oldValue) => {
          console.log(`Updating from ${oldValue} to ${newValue}`);
          this.page_header = this.$store.state.page_header
          this.$forceUpdate();          
        }
      );
      // this.activeIndex='2'
    }
  }
</script>