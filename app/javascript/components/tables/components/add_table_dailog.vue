<template>
  <el-dialog title="Add Table" :visible.sync="dialogFormVisible">
    <el-form :model="table.attributes" :rules="rules" ref="createTable">
      <el-form-item label="" prop="table_code" required >
          <el-input v-model="table.attributes.table_code" placeholder="Table Code"></el-input>
      </el-form-item>

      <el-form-item v-if="board_game" label="" prop="capacity" required>
          <el-input-number v-model="table.attributes.capacity" :min='board_game.attributes.min_player' :max='board_game.attributes.max_player' ></el-input-number>
      </el-form-item>

      <el-form-item label="" prop="board_game_id" required> 
          <el-select @change="table.attributes.capacity = board_game.attributes.min_player" v-model="table.attributes.board_game_id" placeholder="BoardGame">
              <el-option
                  v-for="item in board_games"
                  :key="item.id"

                  :label="item.attributes.name"
                  :value="item.id"
              >
              </el-option>
          </el-select>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button type="success" @click="submitForm('createTable')">Create</el-button>
      <el-button type="warning" @click="resetForm('createTable')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </span>
  </el-dialog>
</template>

<script>
import route_helpers from '../../../services/route_helpers'

export default {
  props:['dialogFormVisible','coffee_shop_id', 'event_id', 'tables'],
  data(){
    var check_unique_table_code = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please input uniqe table code'));
      }
      else {
        if(this.tables.find(item =>{return item.attributes.table_code === value})){
          callback(new Error( ' \''+value + '\' is used'));
        }
        callback();
      }
    };
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
          { validator: check_unique_table_code, trigger: 'blur' }
        ],
        board_game_id: [
          { required: true, message: 'Please input uniqe table code', trigger: 'change' },
        ],
      },
      formLabelWidth:'120px'
    }
  },
  methods:{
    askIsTableCodeUnique(table_code){
      if(this.tables.find(item =>{return item.attributes.table_code === table_code})){
        this.answerIsTableCodeUnique = false
      }
      else{
        this.answerIsTableCodeUnique = true
      }
    },
    callPOST_CoffeeShopEventTables(){
        console.log("callPOST_CoffeeShopEventTables")
        route_helpers.POST().coffee_shop_event_tables(this.coffee_shop_id, this.event_id, this.table.attributes)
            .then((response)=> {console.log(response)})
            .then(()=>{this.$emit('addTable')})
            .then(()=>{this.$emit('update:dialogFormVisible', false)})
    },
    callGET_CoffeeShopBoardGames(){
        console.log("callGET_CoffeeShopBoardGames")
        this.load = false;
        route_helpers.GET().coffee_shop_board_games(this.coffee_shop_id)
            .then(response => {this.board_games = response.data.data})
            .then(() => {this.table.attributes.board_game_id = this.board_games[0].id})
            .then(() => {this.load = true})
    },
    cancel(){
        console.log("cancel")
        this.$emit('update:dialogFormVisible', false)
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
    board_game(){
      return this.board_games.find(item =>{
        return item.id === this.table.attributes.board_game_id
      })
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
