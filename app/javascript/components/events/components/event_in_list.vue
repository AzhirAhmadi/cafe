<template>
  <tr>
    <td style="width:25px"><strong>{{event.id}}</strong></td>
    <td v-if="event.attributes.avatar" style="width:80px">
        <el-avatar :size="50" :src="event.attributes.avatar.image.url"></el-avatar>
    </td>
    <td v-else style="width:80px">
        <el-avatar :size="50" :src="'/img/coffeeShopDefultAvatar.jpg'"></el-avatar>
    </td>
    <td style="text-align: left;">{{event.attributes.name}}</td>
    <td style="width:100px">{{coffee_shop.attributes.name}}</td>
    <td style="width:100px">{{uperCaseStatus}}</td>
    <td style="width:250px">
        <el-button v-if="editAble && current_user && EDIT" type="success" @click="push_event_edit" style="margin: auto;">Edit</el-button>
        <el-button v-if="reActiveAble && current_user && reACTIVE" type="warning" @click="call_reActive" style="margin: auto;">reActive</el-button>
        <el-button v-if="deleteAble && current_user && DELETE" type="danger" @click="callDELETE_event" style="margin: auto;">Delete</el-button>
        <el-button v-if="PROFILE" type="primary" @click="push_event_show" style="margin: auto;">Profile</el-button>
    </td>
  </tr>
</template>

<script>
import RolePower from '../../../services/role_pwoer'
import router from '../../../packs/router'
import { statSync } from 'fs'

export default {
  props: ['coffee_shop', 'event', 'editAble', 'deleteAble', 'reActiveAble'],
  data: function () {
    return {
      
    }
  },
  methods:{
    push_event_edit(){
      console.log("push_event_update")
      router.push('/coffee_shops/'+this.coffee_shop.id+'/events/'+this.event.id+'/update');
    },
    callDELETE_event(){
      console.log("callDELETE_event")  
      this.$eventResource.DELETE_coffee_shop_event(this.coffee_shop.id, this.event.id)
      .then(response => {console.log(response)})
      .then(()=>{this.$emit('removeFromParent', this.event.id);})    
      .catch(error => {error_handler._401("get#users")})
    },
    push_event_show(){
      router.push('/coffee_shops/'+this.coffee_shop.id+'/events/'+this.event.id+'/show');
    },
    call_reActive(){
      console.log("call_reActive");
    }
  },
  computed:{
    uperCaseStatus(){
      return this.event.attributes.status[0].toUpperCase()+ this.event.attributes.status.substr(1);
    },
    EDIT(){
      return RolePower.power(this.current_user.attributes.role)>1 // coffee_owner & expert & admin & master
    },
    DELETE(){
      return RolePower.power(this.current_user.attributes.role)>1 && this.event.attributes.deleted_at === null // admin & master
    },
    PROFILE(){
      return true
    },
    reACTIVE(){
      return RolePower.power(this.current_user.attributes.role)>1 && this.event.attributes.deleted_at !== null // admin & master
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
  padding: 0px 8px 0px 8px;
}

tr:nth-child(even) {
  background-color: #eee;
  
}
</style>