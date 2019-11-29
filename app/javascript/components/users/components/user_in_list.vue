<template>
  <tr>
    <td style="width:25px"><strong>{{user.id}}</strong></td>
    <td style="width:80px">
        <el-avatar :size="50" :src="'/img/img1.jpg'"></el-avatar>
    </td>
    <td style="text-align: left;">{{user.attributes.email}}</td>
    <td style="width:100px">{{user.attributes.role}}</td>
    <td style="width:250px">
      <el-button v-if="EDIT" type="success" @click="push_user_edit" style="margin: auto;">Edit</el-button>
      <el-button v-if="reACTIVE" type="warning" @click="call_reActive" style="margin: auto;">reActive</el-button>
      <el-button v-if="DELETE" type="danger" @click="callDELETE_user" style="margin: auto;">Delete</el-button>
      <el-button v-if="PROFILE" type="primary" @click="push_user_show" style="margin: auto;">Profile</el-button>
    </td>
  </tr>
</template>

<script>
import RolePower from '../../../services/role_pwoer'
import route_helpers from '../../../services/route_helpers'
import router from '../../../packs/router'

export default {
  props: ['user'],
  data: function () {
    return {
      current_user: null
    }
  },
  methods:{
    push_user_edit(){
      console.log("push_user_update")
      router.push('/users/'+this.user.id+'/update');
    },
    callDELETE_user(){
      console.log("callDELETE_user")  
      route_helpers.DELETE().user_deactivate(this.user.id)
      .then(response => {console.log(response)})
      .then(()=>{this.$emit('removeFromParent', this.user.id);})    
    },
    push_user_show(){
      router.push('/users/'+this.user.id+'/show');
    },
    call_reActive(){
      console.log("call_reActive");
    }
  },
  computed:{
    EDIT(){
      return this.current_user && RolePower.GT(this.current_user.attributes.role, this.user.attributes.role)
    },
    DELETE(){
      return this.current_user && RolePower.GT(this.current_user.attributes.role, this.user.attributes.role) && this.user.attributes.deleted_at === null
    },
    PROFILE(){
      return true
    },
    reACTIVE(){
      return this.current_user && RolePower.GT(this.current_user.attributes.role, this.user.attributes.role) && this.user.attributes.deleted_at !== null
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
td, th {
  border: 1px solid #888;
  text-align: center;
  padding: 0px 8px 0px 8px;
}

tr:nth-child(even) {
  background-color: #eee;
  
}
</style>