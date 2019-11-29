<template >
  <div v-if="load"> 
    <el-row v-if="current_user && CREAT_EVENT" style="text-align: right;">
      <router-link :to="{name: 'event_create'}"><el-button type="primary" >Create Event</el-button></router-link>
    </el-row>
    <el-row>
      <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Name</th>
              <th>CoffeeShop</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
            <EventInLIst v-for="(event, index) in events" :coffee_shop='coffee_shop' :event='event' :key='index'
             v-on:removeFromParent="removeEventFromList"
              :editAble="current_user && EDIT_ABLE" :reActiveAble="current_user && RE_ACTIVE_ABLE" :deleteAble="current_user && DELETE_ABLE"/>
      </table>
    </el-row>
  </div>
</template>

<script>
import route_helpers from '../../services/route_helpers'
import EventInLIst from './components/event_in_list'

export default {
  props: ['coffee_shop_id'],
  data: function () {
    return {
      current_user: {},
      events:[],
      coffee_shop: {},
      load: true
    }
  },
  components:{
    EventInLIst
  },
  methods:{
    callEvents(){
      console.log("callEvents")
       route_helpers.GET().coffee_shop_events(this.coffee_shop_id)
       .then(response => {this.events = response.data.data})
    },
    callCoffeeShop(){
      console.log("set loed to false")
      this.load = false;
      route_helpers.GET().coffee_shop(this.coffee_shop_id)
      .then( response => {this.coffee_shop = response.data.data})
      .then(() => {this.load = true})
    },
    removeEventFromList(id){
      for(var i = 0; i < this.events.length; i++){ 
        if (this.events[i].id === id) {
          this.events.splice(i, 1); 
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
    CREAT_EVENT(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
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
    console.log("events#index.created")
    this.callEvents();
    this.callCoffeeShop();

    this.$store.watch(
      (state, getters) => getters.current_user,
      (newValue, oldValue) => {
        console.log(`Updating from ${oldValue} to ${newValue}`);
        this.current_user = this.$store.state.current_user
      }
    );
    this.current_user = this.$store.state.current_user

    this.$store.dispatch('updatePageHeader', 'Events List');
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
