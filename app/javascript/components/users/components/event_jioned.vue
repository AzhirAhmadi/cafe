<template>
  <tr>
    <td>
      <div class="block">
        <el-avatar :size="50" :src="'/img/img1.jpg'"></el-avatar>
      </div>
    </td>
    <td>EventName</td>
    <td>CofeBoard</td>
    <td>10</td>
  </tr>
</template>

<script>
import RolePower from '../../../services/role_pwoer'
import router from '../../../packs/router'

export default {
  props: ['user'],
  data: function () {
    return {
      
    }
  },
  methods:{
    push_user_edit(){
      console.log("push_user_update")
    },
    callDELETE_user(){
      console.log("callDELETE_user")      
    },
    push_user_show(){
      router.push('/users/'+this.user.id+'/show');
    }
  },
  computed:{
    EDIT(){
      return RolePower.GT(this.current_user.role, this.user.attributes.role)
    },
    DELETE(){
      return RolePower.GT(this.current_user.role, this.user.attributes.role)
    },
    PROFILE(){
      return true
    },
    current_user(){
      return this.$store.state.current_user
    }
  }
}
</script>

<style scoped>
td, th {
  border: 1px solid #888;
  text-align: center;
}

tr:nth-child(even) {
  background-color: #eee;
}
</style>