<template>
  <div v-if="load">
    <el-row>
        <el-col :span="6">
            <el-avatar class="temp" :size="200 " :src="'/img/img3.jpg'"></el-avatar>
        </el-col>
        <el-col style="text-align: left;" :span="18" >
            <strong style="font-size: 1.5em;">Name: {{event.attributes.name}}</strong>
            <br>
            <strong >CoffeeShop: {{coffee_shop.attributes.name}}</strong>
            <el-button type="primary" @click="push_coffee_shop_show" style="margin: auto; padding: 10px;"><i class="el-icon-coffee-cup"></i></el-button>
            <br>
            <p class="temp">It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).</p>
        </el-col>
        
    </el-row>
    <el-row>
        <el-col style="text-align: center;" :span="12" >
          <strong >Enrolment: <br>{{event.attributes.enrol_start_time}} <br> {{event.attributes.enrol_end_time}}</strong>
          <br>
          <br>
          <strong >Event: <br>{{event.attributes.event_start_time}} <br> {{event.attributes.event_end_time}}</strong>
        </el-col>
        <el-col style="text-align: center;" :span="12" >
          <el-button type="danger" @click="push_tables_index">Tables</el-button>
          
        </el-col>
    </el-row>
  </div>
</template>

<script>
import route_helpers from '../../services/route_helpers'
import router from '../../packs/router'
export default {
  props: ['coffee_shop_id' ,'id'],
  data: function () {
    return {
      event:{},
      coffee_shop:{},
      load: true,
    }
  },
  components:{
  },
  methods:{
    callGET_Event(){
      console.log("callGET_Event")
      this.load = false;
      route_helpers.GET().coffee_shop_event(this.coffee_shop_id, this.id)
      .then(response => {this.tempName(response.data);})
      .then(() => {this.load = true})
    },
    tempName(data){
        this.event = data.data;
        this.coffee_shop = data.included['0'];
    },
    push_tables_index(){
      this.$router.push('/coffee_shops/'+this.coffee_shop_id+'/events/'+this.id+'/tables/index')
    },
    push_coffee_shop_show(){
      router.push('/coffee_shops/'+this.coffee_shop.id+'/show');
    }
  },
  created(){
    console.log("coffee_shops#show.created")
    this.$store.dispatch('updatePageHeader', 'coffee_shop Show')
    this.callGET_Event()
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
