<template >
  <div v-if="load"> 
    <el-row v-if="current_user && CREAT_TABLE && CHECK_EVENT_STATUS" style="text-align: right;">
      <router-link :to="{name: 'table_create'}"><el-button type="primary" >Create Table</el-button></router-link>
    </el-row>
    <el-row>
      <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>BoardGame</th>
              <th>Palyers</th>
              <th>CoffeeShop</th>
              <th>Event</th>
              <th>Actions</th>
            </tr>
            <TableInList v-for="(table, index) in tables" :coffee_shop='coffee_shop' :event='event' :table='table' :key='index'
             v-on:removeFromParent="removetableFromList"
              :editAble="current_user && EDIT_ABLE" :reActiveAble="current_user && RE_ACTIVE_ABLE" :deleteAble="current_user && DELETE_ABLE"/>
      </table>
    </el-row>
  </div>
</template>

<script>
import route_helpers from '../../services/route_helpers'
import TableInList from './components/table_in_list'

export default {
  props: ['coffee_shop_id', 'event_id'],
  data: function () {
    return {
      current_user: {},
      coffee_shop: {},
      event: {},
      tables:[],
      load: true
    }
  },
  components:{
    TableInList
  },
  methods:{
    callCoffeeShop(){
      console.log("callCoffeeShop")
      route_helpers.GET().coffee_shop(this.coffee_shop_id)
      .then( response => {this.coffee_shop = response.data.data})
    },
    callCoffeeShopEvent(){
      console.log("callCoffeeShopEvent")
      this.load = false;
      route_helpers.GET().coffee_shop_event(this.coffee_shop_id, this.event_id)
      .then( response => {this.event = response.data.data})
      .then(() => {this.load = true})
    },
    callCoofeeShopEventTables(){
      console.log("callCoofeeShopEventTables")
       route_helpers.GET().coffee_shop_event_tables(this.coffee_shop_id, this.event_id)
       .then(response => {this.tables = response.data.data})
    },
    removetableFromList(id){
      for(var i = 0; i < this.tables.length; i++){ 
        if (this.tables[i].id === id) {
          this.tables.splice(i, 1); 
        }
      }
    },
    isMaintainer(){
      return this.current_user !== null && 
             this.current_user.attributes.role === "sys_expert" &&
             this.coffee_shop.relationships.maintainer.data.id === this.current_user.id
    },
    isOwner(){
      return this.current_user !== null && 
             this.current_user.attributes.role === "coffee_owner" &&
             this.coffee_shop.relationships.owner.data.id === this.current_user.id
    },
  },
  computed:{
    CREAT_TABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
    },
    CHECK_EVENT_STATUS(){
      console.log(this.event)
      return this.event.attributes.status !== "ended" &&
            this.event.attributes.status !== "closed"
    },
    EDIT_ABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
    },
    RE_ACTIVE_ABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master"
    },
    DELETE_ABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
    },
  },
  created(){
    console.log("tables#index.created")
    this.callCoffeeShop();
    this.callCoffeeShopEvent();
    this.callCoofeeShopEventTables();

    this.$store.watch(
      (state, getters) => getters.current_user,
      (newValue, oldValue) => {
        console.log(`Updating from ${oldValue} to ${newValue}`);
        this.current_user = this.$store.state.current_user
      }
    );
    this.current_user = this.$store.state.current_user

    this.$store.dispatch('updatePageHeader', 'Tables List');
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
