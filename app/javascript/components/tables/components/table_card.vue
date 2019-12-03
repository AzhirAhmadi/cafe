<template>
  <el-card v-if="load" class="box-card">
        <div slot="header" class="clearfix">
          <span>{{board_game.attributes.name}}</span>
          <el-button style="float: right; padding: 3px 0" type="text">Operation button</el-button>
          <el-button v-if="editAble     && EDIT"     @click="push_table_edit"    type="primary" icon="el-icon-edit"         circle style="margin: auto;"></el-button>
        </div>
        <div v-for="o in 4" :key="o" class="text item">
          {{'List item ' + o }}
        </div>
    <div v-if="current_user">
      <el-button v-if="editAble     && EDIT"     @click="push_table_edit"    type="primary" icon="el-icon-edit"         circle style="margin: auto;"></el-button>
      <el-button v-if="reActiveAble && reACTIVE" @click="call_reActive"      type="warning" icon="el-icon-refresh-left" circle style="margin: auto;"></el-button>
      <el-button v-if="deleteAble   && DELETE"   @click="callDELETE_table"   type="danger"  icon="el-icon-delete"       circle style="margin: auto;"></el-button>
    </div>
  </el-card>
</template>

<script>
import RolePower from '../../../services/role_pwoer'
import route_helpers from '../../../services/route_helpers'
import router from '../../../packs/router'

export default {
  props: ['coffee_shop', 'event', 'table', 'editAble', 'deleteAble', 'reActiveAble'],
  data: function () {
    return {
      current_user: {},
      board_game:{},
      load: true,
    }
  },
  methods:{
    callCoffeeShopBoardGame(){
      console.log("callCoffeeShopBoardGame")
      this.load = false;
      route_helpers.GET().coffee_shop_board_game(this.coffee_shop.id, this.table.relationships.board_game.data.id)
      .then( response => {this.board_game = response.data.data})
      .then(() => {this.load = true})
      console.log(this.table.id)
    },
    push_table_edit(){
      console.log("push_table_update")
      router.push('/coffee_shops/'+this.coffee_shop.id+'/events/'+this.event.id+'/tables/'+this.table.id+'/update');
    },
    callDELETE_table(){
      console.log("callDELETE_table")  
      route_helpers.DELETE().coffee_shop_event_table_deactivate(this.coffee_shop.id, this.event.id, this.table.id)
      .then(response => {console.log(response)})
      .then(()=>{this.$emit('removeFromParent', this.table.id);})    
      .catch(error => {error_handler._401("get#users")})
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
    this.callCoffeeShopBoardGame();
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

  .box {
    width: 400px;
  }
    .top {
      text-align: center;
    }

    .left {
      float: left;
      width: 110px;
    }

    .right {
      float: right;
      width: 110px;
    }

    .bottom {
      clear: both;
      text-align: center;
    }

    .item {
      margin: 4px;
    }

    .left .el-tooltip__popper,
    .right .el-tooltip__popper {
      padding: 8px 10px;
    }
</style>