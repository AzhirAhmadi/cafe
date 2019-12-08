<template>
  <div v-if="load">
    <el-row>
        <el-col :span="6">
            <el-avatar class="temp" :size="200 " :src="'/img/img4.jpg'"></el-avatar>
        </el-col>
        <el-col style="text-align: left;" :span="6" >
            <strong style="font-size: 1.5em;">Name: {{board_game.attributes.name}}</strong>
            <br>
            <strong >CoffeeShop: {{coffee_shop.attributes.name}}</strong><br>
            <strong >Publisher:  {{board_game.attributes.publisher}}</strong><br>
            <strong >MinPlayer:  {{board_game.attributes.min_player}}</strong><br>
            <strong >MaxPlayer:  {{board_game.attributes.max_player}}</strong><br>
            <strong >PlayTime:  {{board_game.attributes.play_time}}</strong><br>
            <el-button type="primary" @click="push_coffee_shop_show" style="margin: auto; padding: 10px;"><i class="el-icon-coffee-cup"></i></el-button>
            <br>
            <p class="temp">{{coffee_shop.attributes.description}}</p>
        </el-col>
        <el-col style="text-align: left;" :span="12" >
            <p >{{board_game.attributes.description}}</p>
        </el-col>
    </el-row>
  </div>
</template>

<script>
import router from '../../packs/router'

export default {
  props: ['coffee_shop_id' ,'id'],
  data: function () {
    return {
      board_game:{
        attributes:{
          name: "",
          publisher: "",
          description: "",
          min_player: null,
          max_player: null,
          play_time: null,
        }
      },
      coffee_shop:{},
      load: true,
    }
  },
  components:{
  },
  methods:{
    callGET_BoardGame(){
      console.log("callGET_BoardGame")
      this.load = false;
      this.$boardGameResource.GET_coffee_shop_board_game(this.coffee_shop_id, this.id)
      .then(response => {this.tempName(response.data);})
      .then(() => {this.load = true})
    },
    tempName(data){
        this.board_game = data.data;
        this.coffee_shop = data.included['0'];
    },
    push_tables_index(){
      this.$router.push('/coffee_shops/'+this.coffee_shop_id+'/board_games/'+this.id+'/tables/index')
    },
    push_coffee_shop_show(){
      router.push('/coffee_shops/'+this.coffee_shop.id+'/show');
    }
  },
  created(){
    console.log("board_game#show.created")
    this.$store.dispatch('updatePageHeader', 'BoardGame Show')
    this.callGET_BoardGame()
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
