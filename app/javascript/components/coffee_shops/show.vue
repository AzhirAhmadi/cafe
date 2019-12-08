<template>
  <div v-if="load">
    <el-row>
        <el-col class="temp" :span="6" >
            <el-avatar :size="200 " :src="'/img/img2.jpg'"></el-avatar>
        </el-col>
        <el-col style="text-align: left;" :span="18" >
            <strong style="font-size: 1.5em;">Name: {{coffee_shop.attributes.name}}</strong>
            <br>
            <strong >Address: {{coffee_shop.attributes.address}}</strong><br>
            <strong >Owner: {{owner.attributes.email}}</strong><br>
            <strong >Maintainer: {{maintainer.attributes.email}}</strong><br>
            <p class="temp">It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).</p>
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
