<template>
  <div v-if="load">
    <el-row>
        <el-col :span="6" >
          <el-avatar v-if="coffee_shop.attributes.avatar" :size="200" :src="coffee_shop.attributes.avatar.image.url"></el-avatar>
          <el-avatar  v-else :size="200" :src="'/img/coffeeShopDefultAvatar.jpg'"></el-avatar>
        </el-col>
        <el-col style="text-align: left;" :span="18" >
            <strong style="font-size: 1.5em;">Name: {{coffee_shop.attributes.name}}</strong>
            <br>
            <strong >Address: {{coffee_shop.attributes.address}}</strong><br>
            <strong >Owner: {{owner.attributes.email}}</strong><br>
            <strong >Maintainer: {{maintainer.attributes.email}}</strong><br>
        </el-col>
    </el-row>
    <el-row>
        <el-col style="text-align: center;" :span="12" >
          <el-button type="danger" @click="push_events_index">Events</el-button>
        </el-col>
        <el-col style="text-align: center;" :span="12" >
          <el-button type="danger" @click="push_board_games_index">BoardGames</el-button>
        </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data: function () {
    return {
      coffee_shop: {},
      owner:{},
      maintainer:{},
      load: true,
    }
  },
  components:{
  },
  methods:{
    callGET_CoffeeShop(){
      console.log("callcoffee_shops")
      this.load = false;
      this.$coffeeShopResource.GET_coffee_shop(this.id)
      .then(response => {this.tempName(response.data);})
      .then(() => {this.load = true})
    },
    tempName(data){
      this.coffee_shop = data.data;
      this.owner = data.included['0'];
      this.maintainer = data.included['1'];
    },
    push_events_index(){
      this.$router.push('/coffee_shops/'+this.coffee_shop.id+'/events/index')
    },
    push_board_games_index(){
      this.$router.push('/coffee_shops/'+this.coffee_shop.id+'/board_games/index')
    }
  },
  created(){
    console.log("coffee_shops#show.created")
    this.$store.dispatch('updatePageHeader', 'coffee_shop Show')
    this.callGET_CoffeeShop()
  }
}
</script>

<style scoped>
  p {
    font-size: 1em;
    text-align: left;
  }
  .table-header {
    background-color: #eee;
    border: #333 solid 2px;
  }

  .temp{
    background-color: red;
  }
</style>
