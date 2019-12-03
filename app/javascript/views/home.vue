<template>
  <el-container>
    <el-header style="padding: 0px;">
      <TopNavBar></TopNavBar>
    </el-header>
    <el-row class="tac">
        <el-col :span="20" >
          <el-main>
            <router-view/>
          </el-main>
        </el-col>
        
        <el-col :span="4">
            <RightNavBar></RightNavBar>
        </el-col>
    </el-row>
  </el-container>
</template>

<script>
  import RightNavBar from '../components/shard/right_nav_bar.vue'
  import TopNavBar from '../components/shard/top_nav_bar.vue'

  export default {
    components:{
      RightNavBar,
      TopNavBar
    },
    data: function () {
      return {
        current_user: null
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
    }
  }
</script>

<style>
p {
  font-size: 2em;
  text-align: center;
}
body{
  height: 100%;
  margin: 0 !important;
}
</style>
