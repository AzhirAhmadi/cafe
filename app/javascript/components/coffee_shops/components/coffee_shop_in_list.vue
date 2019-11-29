<template>
  <tr>
    <td style="width:25px"><strong>{{coffee_shop.id}}</strong></td>
    <td style="width:80px">
        <el-avatar :size="50" :src="'/img/img2.jpg'"></el-avatar>
    </td>
    <td style="width:100px">{{coffee_shop.attributes.name}}</td>
    <td style="text-align: left;">{{coffee_shop.attributes.address}}</td>
    <td style="width:250px">
        <el-button v-if="editAble && current_user && EDIT" type="success" @click="push_coffee_shop_edit" style="margin: auto;">Edit</el-button>
        <el-button v-if="reActiveAble && current_user && reACTIVE" type="warning" @click="call_reActive" style="margin: auto;">reActive</el-button>
        <el-button v-if="deleteAble && current_user && DELETE" type="danger" @click="callDELETE_coffee_shop" style="margin: auto;">Delete</el-button>
        <el-button v-if="PROFILE" type="primary" @click="push_coffee_shop_show" style="margin: auto;">Profile</el-button>
    </td>
  </tr>
</template>

<script>
import RolePower from '../../../services/role_pwoer'
import route_helpers from '../../../services/route_helpers'
import router from '../../../packs/router'

export default {
  props: ['coffee_shop', 'editAble', 'deleteAble', 'reActiveAble'],
  data: function () {
    return {
      current_user: null
    }
  },
  methods:{
    push_coffee_shop_edit(){
      console.log("push_coffee_shop_update")
      router.push('/coffee_shops/'+this.coffee_shop.id+'/update');
    },
    callDELETE_coffee_shop(){
      console.log("callDELETE_coffee_shop")  
      route_helpers.DELETE().coffee_shop_deactivate(this.coffee_shop.id)
      .then(response => {console.log(response)})
      .then(()=>{this.$emit('removeFromParent', this.coffee_shop.id);})    
    },
    push_coffee_shop_show(){
      router.push('/coffee_shops/'+this.coffee_shop.id+'/show');
    },
    call_reActive(){
      console.log("call_reActive");
    }
  },
  computed:{
    EDIT(){
      return RolePower.power(this.current_user.attributes.role)>1 // coffee_owner & expert & admin & master
    },
    DELETE(){
      return RolePower.power(this.current_user.attributes.role)>1 && this.coffee_shop.attributes.deleted_at === null // admin & master
    },
    PROFILE(){
      return true
    },
    reACTIVE(){
      return RolePower.power(this.current_user.attributes.role)>1 && this.coffee_shop.attributes.deleted_at !== null // admin & master
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