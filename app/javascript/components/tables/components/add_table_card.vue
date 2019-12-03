<template>
    <el-card  class="box-card">
        <div slot="header" class="clearfix">
            <strong>Add New Tbale</strong>
            <el-button  style="height: 30px; width: 30px; float: right; padding: 3px 0" type="success" icon="el-icon-check" circle @click="submitForm('createTable')"></el-button>
        </div>
              
        <el-form :model="table.attributes"
         :rules="rules" 
         ref="createTable"
         label-width="100px"
         >
            <el-form-item label="" prop="table_code" required >
                <el-input v-model="table.attributes.table_code" placeholder="Table Code"></el-input>
            </el-form-item>

            <el-form-item v-if="board_game" label="" prop="capacity" required>
                <el-input-number v-model="table.attributes.capacity" :min='MinPalyer' :max="10" ></el-input-number>
            </el-form-item>

            <el-form-item label="" prop="board_game" required> 
                <el-select @change="callGET_BoardGame" v-model="table.attributes.board_game_id" placeholder="BoardGame">
                    <el-option
                        v-for="item in board_games"
                        :key="item.id"

                        :label="item.attributes.name"
                        :value="item.id"
                    >
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="success" @click="submitForm('createTable')">Create</el-button>
                <!-- <el-button type="warning" @click="resetForm('createTable')">Reset</el-button> -->
                <!-- <el-button type="danger" @click="cancel">Cancel</el-button> -->
            </el-form-item>
        </el-form>
    </el-card>
</template>

<script>
import route_helpers from '../../../services/route_helpers'

export default {
  props:["coffee_shop_id", 'event_id'],
  data(){
    return {
      table: {
        attributes:{
          capacity: 0,
          table_code: "",
          board_game_id: null,
        }
      },
      board_game: {},
      board_games: [],
      rules: {
        capacity: [
          { required: true, message: 'Please input boardgame capacity', trigger: 'change' },
        ],
        table_code: [
          { required: true, message: 'Please input uniqe table code', trigger: 'change' },
        ],
        board_game: [
          { required: true, message: 'Please input uniqe table code', trigger: 'change' },
        ],
      },
    }
  },
  methods:{
    callPOST_CoffeeShopEventTables(){
        console.log("callPOST_CoffeeShopEventTables")
        route_helpers.POST().coffee_shop_event_tables(this.coffee_shop_id, this.event_id, this.table.attributes)
            .then((response)=> {console.log(response)})
            .then(()=>{this.$router.go(-1)})
    },
    callGET_CoffeeShopBoardGames(){
        console.log("callGET_CoffeeShopBoardGames")
        this.load = false;
        route_helpers.GET().coffee_shop_board_games(this.coffee_shop_id)
            .then(response => {this.board_games = response.data.data})
            .then(() => {this.table.attributes.board_game_id = this.board_games[0].id})
            .then(() => {this.load = true})
    },
    callGET_BoardGame(){
        console.log("callGET_BoardGame")
        this.load = false;
        route_helpers.GET().coffee_shop_board_game(this.coffee_shop_id, this.table.attributes.board_game_id)
            .then(response => { this.board_game = response.data.data})
            .then(() => {this.load = true})
    },
    cancel(){
        console.log("cancel")
        this.$router.go(-1)
    },
    submitForm(formName) {
        this.$refs[formName].validate((valid) => {
            if (valid) {
                this.callPOST_CoffeeShopEventTables();
            } else {
                return false;
            }
        });
    },
    resetForm(formName) {
        this.$refs[formName].resetFields();
    }
  },
  computed:{
      MinPalyer(){
        console.log(this.board_game.attributes)
        console.log("ddddddddddddddddddddddddd")
        return 0;
      }
  },
  created(){
    console.log("tables#add_card")
    this.callGET_CoffeeShopBoardGames()
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
  
}
</style>
