<template>
  <el-form :model="board_game.attributes" :rules="rules" ref="createBoardGame" label-width="200px">
    
    <el-form-item label="BoardGame name" prop="name" required>
      <el-input v-model="board_game.attributes.name"></el-input>
    </el-form-item>

    <el-form-item label="BoardGame publisher" prop="publisher" required>
      <el-input v-model="board_game.attributes.publisher"></el-input>
    </el-form-item>

    <el-form-item label="BoardGame description" prop="description" required>
      <el-input type="textarea" v-model="board_game.attributes.description"></el-input>
    </el-form-item>

    <el-form-item label="BoardGame min_player" prop="min_player" required>
      <el-input v-model="board_game.attributes.min_player"></el-input>
    </el-form-item>

    <el-form-item label="BoardGame max_player" prop="max_player" required>
      <el-input v-model="board_game.attributes.max_player"></el-input>
    </el-form-item>

    <el-form-item label="BoardGame play_time(min)" prop="play_time" required>
      <el-input v-model="board_game.attributes.play_time"></el-input>
    </el-form-item>

    <el-form-item>
      <el-button type="success" @click="submitForm('createBoardGame')">Save</el-button>
      <el-button type="warning" @click="resetForm('createBoardGame')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import route_helpers from '../../services/route_helpers'

export default {
  props:['coffee_shop_id', 'id'],
  data(){
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
      rules: {
        name: [
          { required: true, message: 'Please input boardgame name', trigger: 'change' },
        ],
        min_player: [
          { required: true, message: 'Please input boardgame minimum players number', trigger: 'change' },
          { min: 1, max: 20, message: 'Min Player should be 1 to 20', trigger: 'change' }
        ],
        max_player: [
          { required: true, message: 'Please input boardgame maximum players number', trigger: 'change' },
          { min: 1, max: 20, message: 'Max player should be 1 to 20', trigger: 'change' }
        ],
        play_time: [
          { required: true, message: 'Please input boardgame playing time', trigger: 'change' },
          { min: 0, max: 240, message: 'Paly time should be 0 to 240', trigger: 'change' }
        ],
        description: [
          { required: true, message: 'Please input boardgame description', trigger: 'change' },
        ],
      },
    }
  },
  methods:{
    callBoardGameUpdate(){
      console.log("callBoardGameUpdate")
      route_helpers.PUT().coffee_shop_board_game(this.coffee_shop_id, this.id, this.board_game.attributes)
      .then((response)=> {console.log(response)})
      .then(()=>{this.$router.go(-1)})
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.callBoardGameUpdate();
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
    console.log("coffee_shops#create.created")
    this.$store.dispatch('updatePageHeader', 'Create BoardGame');
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>