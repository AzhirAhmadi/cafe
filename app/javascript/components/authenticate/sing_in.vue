<template>
    <div id="content">
      <div>  
        <el-row>
          <el-col :span="6" :push="9" >
            <div style="text-align: center; margin: 0">
              <el-input placeholder="email" v-model="email"></el-input>
              <el-input placeholder="password" v-model="password" show-password></el-input>
            </div>
            <br>
            <div style="text-align: center; margin: 0">
              <el-button type="success" @click="callLogin">SingIn</el-button>
              <el-button type="primary" @click="cancel">Cancel</el-button>
            </div>
          </el-col>
        </el-row>










        <br>
        <br>
        <el-row>
          <el-col :span="12" :push="6" >
                <el-button type="success" @click="Mster">Mster</el-button>
                <el-button type="success" @click="Admin">Admin</el-button>
                <el-button type="success" @click="Expert">Expert</el-button>
                <el-button type="success" @click="CoffeeOwner">CoffeeOwner</el-button>
                <el-button type="success" @click="Player">Player</el-button>
          </el-col>
        </el-row>
      </div>
    </div>
</template>


<script>
  import route_helpers from '../../services/route_helpers'
  // import {mapState} from 'vuex'
  
  export default {
    data(){
      return {
        email:"",
        password: ""
      }
    },
    methods:{
      Mster(){
        route_helpers.DEVICE().login("azhir@master.com", "123456")
        .then(response =>{this.$store.dispatch('updateAuthToken', response.data.jwt)})
        .then(this.callProfile)
      },
      Admin(){
        route_helpers.DEVICE().login("azhir@admin.com", "123456")
        .then(response =>{this.$store.dispatch('updateAuthToken', response.data.jwt)})
        .then(this.callProfile)
      },
      Expert(){
        route_helpers.DEVICE().login("azhir@expert.com", "123456")
        .then(response =>{this.$store.dispatch('updateAuthToken', response.data.jwt)})
        .then(this.callProfile)
      },
      CoffeeOwner(){
        route_helpers.DEVICE().login("azhir@cafe_owner.com", "123456")
        .then(response =>{this.$store.dispatch('updateAuthToken', response.data.jwt)})
        .then(this.callProfile)
      },
      Player(){
        route_helpers.DEVICE().login("azhir@player.com", "123456")
        .then(response =>{this.$store.dispatch('updateAuthToken', response.data.jwt)})
        .then(this.callProfile)
      },
      callLogin(){
        route_helpers.DEVICE().login(this.email,this.password)
        .then(response =>{this.$store.dispatch('updateAuthToken', response.data.jwt)})
        .then(this.callProfile)
      },
      callProfile(){
        route_helpers.GET().profile()
        .then(response =>{this.$store.dispatch('updateCurrentUser', response.data.data)})
        .then(this.cancel)
      },
      cancel(){
        this.$router.go(-1)
      }
    },
    created(){
      this.$store.dispatch('updatePageHeader', 'Sing In')
    }
  }
</script>

<style scoped>

#content{
  text-align:center;
  margin:auto; 
}
</style>