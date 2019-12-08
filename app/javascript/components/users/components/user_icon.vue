<template>
  <div>
    <el-row>
      <el-col :span="6" >
        <div style="text-align: center; margin: 0">
          <div class="block"><el-avatar :size="50" :src="'/img/img1.jpg'"></el-avatar></div>
        </div>
      </el-col>
      <el-col :span="11">
        <div style="text-align: left; margin: 0">
          <p class="truncate">{{user.attributes.email}}</p>
          <p>{{user.attributes.role}}</p>
        </div>
      </el-col>
      <el-col :span="6">
        <el-popover
        placement="bottom"
        width="150"
        trigger="manual"
        v-model="visible">
          <p  style="text-align: center; margin: 0">{{user.attributes.email}}</p>
          <p  style="text-align: center; margin: 0">{{user.attributes.role}}</p>
          <el-divider></el-divider>
          <div style="text-align: center; margin: 0">
            <el-button type="success" @click="push_user_edit"><i class="el-icon-edit"></i></el-button>
            <el-button type="danger" @click="callDEVISE_logout"><i class="el-icon-switch-button "></i></el-button>
          </div>
          
          <el-button slot="reference" @click="visible = !visible" type="success" >
                <i class="el-icon-setting"/>
          </el-button>
        </el-popover>
      </el-col>
    </el-row>

    
  </div>
</template>

<script>
import router from '../../../packs/router'

export default {
  props: ['user'],
  data(){
      return {
        visible: false
      }
  },
  methods: {
    push_user_edit(){
      console.log("push_user_update")
      router.push('/users/'+this.current_user.id+'/update');
    },
    callDEVISE_logout(){
      console.log("callDEVISE_logout")
      this.$deviseResource.DELETE_logout()
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

<style scoped>
.truncate {
  width: 90%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
p{
  font-size: 18px;
  margin: 0 !important;
  text-align: left;
}
</style>