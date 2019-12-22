<template>
  <el-form v-if="load" :model="board_game.attributes" :rules="rules" ref="updateBoardGame" label-width="200px">
    
      
    <el-form-item>
      <Uploader @onImageChange="setImage" :image="board_game.attributes.avatar"/>
    </el-form-item>

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
      <el-button type="success" @click="submitForm('updateBoardGame')">Save</el-button>
      <el-button type="warning" @click="resetForm('updateBoardGame')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import Uploader from '../shard/singleImageUploader'
export default {
  props:['coffee_shop_id', 'id'],
  data(){
    return {
      load: true,
      board_game:{
        attributes:{
          name: "",
          publisher: "",
          description: "",
          min_player: null,
          max_player: null,
          play_time: null,
          image: null
        }
      },
      rules: {
        name: [
          { required: true, message: 'Please input boardgame name', trigger: 'change' },
        ],
        min_player: [
          { required: true, message: 'Please input boardgame minimum players number', trigger: 'change' },
        ],
        max_player: [
          { required: true, message: 'Please input boardgame maximum players number', trigger: 'change' },
        ],
        play_time: [
          { required: true, message: 'Please input boardgame playing time', trigger: 'change' },
        ],
        description: [
          { required: true, message: 'Please input boardgame description', trigger: 'change' },
        ],
      },
    }
  },
  methods:{
    callGET_coffee_shop__board_game(){
      console.log("callGET_coffee_shop__board_game")
      this.load = false
      this.$boardGameResource.GET_coffee_shop_board_game(this.coffee_shop_id, this.id)
      .then((response) => {this.board_game.attributes = response.data.data.attributes})
      .then(() => {this.load = true})
    },
    callPUT_coffee_shop_board_game(){
      console.log("callPUT_coffee_shop_board_game")
      this.$boardGameResource.PUT_coffee_shop_board_game(this.coffee_shop_id, this.id, this.board_game.attributes)
      .then((response)=> {console.log(response)})
      .then(()=>{this.$router.go(-1)})
    },
    setImage(file){
      this.board_game.attributes.image = file.raw
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.callPUT_coffee_shop_board_game();
        } else {
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    }
  },
  components:{
    Uploader,
  },
  computed:{
  },
  created(){
    console.log("board_games#update.created")
    this.$store.dispatch('updatePageHeader', 'Update BoardGame');
    this.callGET_coffee_shop__board_game()
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>