<template>
  <el-form :model="table.attributes" :rules="rules" ref="createTable" label-width="200px">

    <el-form-item label="Table table_code" prop="table_code" required>
      <el-input v-model="table.attributes.table_code"></el-input>
    </el-form-item>

    <el-form-item label="BoardGame" prop="owner_id"> 
      <el-select v-model="table.attributes.board_game_id" placeholder="Select">
        <el-option
          v-for="item in board_games"
          :key="item.id"
          :label="item.attributes.name"
          :value="item.id">
        </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Table capacity" prop="capacity" required>
      <el-input v-model="table.attributes.capacity"></el-input>
    </el-form-item>

    <el-form-item>
      <el-button type="success" @click="submitForm('createTable')">Create</el-button>
      <el-button type="warning" @click="resetForm('createTable')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import route_helpers from '../../services/route_helpers'

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
       route_helpers.GET().coffee_shop_board_games(this.coffee_shop_id)
       .then(response => {this.board_games = response.data.data})
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
  },
  created(){
    console.log("tables#create.created")
    this.$store.dispatch('updatePageHeader', 'Create BoardGame');
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
