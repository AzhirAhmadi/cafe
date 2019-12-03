<template>
  <div v-if="load">
    <el-row v-if="current_user && CREATE_COFFEE_SHOP" style="text-align: right;">
      <router-link :to="{name: 'coffee_shop_create'}"><el-button type="primary" >Create CoffeeShop</el-button></router-link>
    </el-row>
    <el-row>
      <table style="width:100%">
            <tr>
              <th>ID</th>
              <th>Avatar</th>
              <th>Name</th>
              <th>Adderss</th>
              <th>Actions</th>
            </tr>
            <CoffeeShopInList v-for="(coffee_shop, index) in coffee_shops" :coffee_shop='coffee_shop' :key='index'
             v-on:removeFromParent="removeCoffeeShopFromList"
             :editAble='current_user && EDIT_ABLE(coffee_shop)'
              :reActiveAble='current_user && RE_ACTIVE_ABLE(coffee_shop)' 
              :deleteAble='current_user && DELETE_ABLE(coffee_shop)'/>
      </table>
    </el-row>
  </div>
</template>

<script>
import route_helpers from '../../services/route_helpers'
import CoffeeShopInList from './components/coffee_shop_in_list'
export default {
  data: function () {
    return {
      coffee_shops:[],
      current_user: null,
      load: true,
    }
  },
  components:{
    CoffeeShopInList
  },
  methods:{
    callCoffeeShops(){
      console.log("callCoffeeShops")
      this.load = false
       route_helpers.GET().coffee_shops()
       .then(response => {this.coffee_shops = response.data.data})
       .then(()=>{this.load = true})
    },
    removeCoffeeShopFromList(id){
      for(var i = 0; i < this.coffee_shops.length; i++){ 
        if (this.coffee_shops[i].id === id) {
          this.coffee_shops.splice(i, 1); 
        }
      }
    },
    isMaintainer(data){
      return this.current_user !== null && 
             this.current_user.attributes.role === "sys_expert" &&
             data.relationships.maintainer.data.id === this.current_user.id
    },
    isOwner(data){
      return this.current_user !== null && 
             this.current_user.attributes.role === "coffee_owner" &&
             data.relationships.owner.data.id === this.current_user.id
    },
    EDIT_ABLE(data){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer(data) ||
          this.isOwner(data)
    },
    RE_ACTIVE_ABLE(data){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master"
    },
    DELETE_ABLE(data){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer(data) ||
          this.isOwner(data)
    },
  },
  computed:{
    CREATE_COFFEE_SHOP(){
      return this.current_user.attributes.role === "sys_admin" ||
            this.current_user.attributes.role === "sys_master"
    },
  },
  created(){
    console.log("coffee_shops#index.created")
    this.$store.dispatch('updatePageHeader', 'CooffeeShops List');

    this.$store.watch(
      (state, getters) => getters.current_user,
      (newValue, oldValue) => {
        console.log(`Updating from ${oldValue} to ${newValue}`);
        this.current_user = this.$store.state.current_user
        // this.$forceUpdate();          
      }
    );
    this.current_user = this.$store.state.current_user
    this.callCoffeeShops()
  }
}
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
