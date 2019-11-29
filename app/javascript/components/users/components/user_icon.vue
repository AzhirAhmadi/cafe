<template>
  <div>
    <el-row>
      <el-col :span="6" >
        <div style="text-align: center; margin: 0">
          <div class="block"><el-avatar :size="50" :src="'/img/img1.jpg'"></el-avatar></div>
        </div>
      </el-col>
      <el-col :span="13" :push="1">
        <div style="text-align: left; margin: 0">
          <strong>{{user.attributes.email}}</strong>
          <br>
          <strong>{{user.attributes.role}}</strong>
        </div>
      </el-col>
      <el-col :span="4">
        <el-popover
        placement="bottom"
        width="200"
        trigger="manual"
        v-model="visible">
          <el-button type="success" @click="push_user_edit">Edit</el-button>
          <el-button type="danger" @click="callDEVISE_logout">SingOut</el-button>

          <el-button slot="reference" @click="visible = !visible" type="success" >
                <i class="el-icon-setting"/>
          </el-button>
        </el-popover>
      </el-col>
    </el-row>

    
  </div>
</template>

<script>
  import route_helper from '../../../services/route_helpers'
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
