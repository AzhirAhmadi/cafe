<template>
  <tr>
    <td style="width:25px"><strong>{{board_game.id}}</strong></td>
    <td style="width:80px">
        <el-avatar :size="50" :src="'/img/img4.jpg'"></el-avatar>
    </td>
    <td style="text-align: left;">{{board_game.attributes.name}}</td>
    <td style="width:100px">{{coffee_shop.attributes.name}}</td>
    <td style="width:100px">test</td>
    <td style="width:250px">
        <el-button v-if="editAble && current_user && EDIT" type="success" @click="push_board_game_edit" style="margin: auto;">Edit</el-button>
        <el-button v-if="reActiveAble && current_user && reACTIVE" type="warning" @click="call_reActive" style="margin: auto;">reActive</el-button>
        <el-button v-if="deleteAble && current_user && DELETE" type="danger" @click="callDELETE_board_game" style="margin: auto;">Delete</el-button>
        <el-button v-if="PROFILE" type="primary" @click="push_board_game_show" style="margin: auto;">Profile</el-button>
    </td>
  </tr>
</template>

<script>
import RolePower from '../../../services/role_pwoer'
import router from '../../../packs/router'

export default {
  props: ['coffee_shop', 'board_game', 'editAble', 'deleteAble', 'reActiveAble'],
  data: function () {
    return {
      
    }
  },
  methods:{
    push_board_game_edit(){
      console.log("push_board_game_update")
      router.push('/coffee_shops/'+this.coffee_shop.id+'/board_games/'+this.board_game.id+'/update');
    },
    callDELETE_board_game(){
      console.log("callDELETE_board_game")  
      this.$boardGameResource.DELETE_coffee_shop_board_game_deactivate(this.coffee_shop.id, this.board_game.id)
      .then(response => {console.log(response)})
      .then(()=>{this.$emit('removeFromParent', this.board_game.id);})    
      .catch(error => {error_handler._401("get#users")})
    },
    push_board_game_show(){
      router.push('/coffee_shops/'+this.coffee_shop.id+'/board_games/'+this.board_game.id+'/show');
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
      return RolePower.power(this.current_user.attributes.role)>1 && this.board_game.attributes.deleted_at === null // admin & master
    },
    PROFILE(){
      return true
    },
    reACTIVE(){
      return RolePower.power(this.current_user.attributes.role)>1 && this.board_game.attributes.deleted_at !== null // admin & master
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