<template>
  <div>
    <el-row>
        <el-col class="temp" :span="6" >
            <el-avatar :size="200 " :src="'/img/img1.jpg'"></el-avatar>
        </el-col>
        <el-col style="text-align: left;" :span="18" >
            <strong style="font-size: 1.5em;">{{user.attributes.email}}</strong>
            <br>
            <strong >{{user.attributes.role}}</strong>
            <p class="temp">It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).</p>
        </el-col>
    </el-row>
    <el-row class="temp">
        <el-col style="text-align: center;" :span="12" >
          <table style="width:100%; border: #333 solid 1px;">
            <tr class="table-header">
              <th>Game Played</th>
            </tr>
            <tr>
              <table style="width:100%">
                <tr>
                  <th>Avatar</th>
                  <th>Name</th>
                  <th>Publisher</th>
                  <th>Play Count</th>
                </tr>
                <BoardGamePlayed/>
                <BoardGamePlayed/>
                <BoardGamePlayed/>
                <BoardGamePlayed/>
                <BoardGamePlayed/>
              </table>
            </tr>
          </table>
        </el-col>
        <el-col style="text-align: center;" :span="12" >
          <table style="width:100%; border: #333 solid 1px;">
            <tr class="table-header">
              <th>Events Joined</th>
            </tr>
            <tr>
              <table style="width:100%">
                <tr>
                  <th>Avatar</th>
                  <th>Name</th>
                  <th>Holder</th>
                  <th>Play Count</th>
                </tr>
                <EventJoined/>
                <EventJoined/>
                <EventJoined/>
                <EventJoined/>
                <EventJoined/>
              </table>
            </tr>
          </table>
        </el-col>
    </el-row>
  </div>
</template>

<script>
import BoardGamePlayed from './components/board_game_played'
import EventJoined from './components/event_jioned'

export default {
  props: ['id'],
  data: function () {
    return {
      user: {}
    }
  },
  components:{
    BoardGamePlayed,
    EventJoined
  },
  methods:{
    callGET_User(){
      console.log("callUsers")
       this.$userResource.GET_user(this.id)
       .then(response => {this.user = response.data.data})
    }
  },
  created(){
    console.log("users#show.created")
    this.$store.dispatch('updatePageHeader', 'User Show')
    this.callGET_User()
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
