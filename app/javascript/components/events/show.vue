<template>
  <div v-if="load">
    <el-row>
        <el-col :span="6">
            <el-avatar class="temp" :size="200 " :src="'/img/img3.jpg'"></el-avatar>
        </el-col>

        <el-col style="text-align: left;" :span="6" >
          <strong style="font-size: 1.5em;">Name:
            {{event.attributes.name}} ({{uperCaseStatus}})
          </strong>
          <br>
          <strong >CoffeeShop:
            {{coffee_shop.attributes.name}}
          </strong>
          <el-button type="primary" @click="push_coffee_shop_show" style="margin: auto; padding: 10px;">
            <i class="el-icon-coffee-cup"/>
          </el-button>
            <br>
          <strong >Enrolment:
            <br>{{event.attributes.enrol_start_time}}
            <br>{{event.attributes.enrol_end_time}}
          </strong>
          <br>
          <br>
          <strong >Event:
            <br>{{event.attributes.event_start_time}}
            <br> {{event.attributes.event_end_time}}
          </strong>
            
        </el-col>
        <el-col style="text-align: center;" :span="12" >
          <p>{{event.attributes.description}}</p>
        </el-col>
    </el-row>
    <br>
    <el-row v-if="current_user && CREAT_TABLE">
      <el-col :span='20'>
              <el-divider><strong>Tables</strong></el-divider>
      </el-col>
      <el-col style="text-align: center;" :span='4'>
        <el-divider content-position="right">
          <el-button  style="height: 50px; width: 50px; float: right; padding: 3px 0"
            circle @click="add = !add"
            type="success" icon="el-icon-plus" 
          ></el-button>
        </el-divider>
      </el-col>
    </el-row>
    <el-divider v-else>
      <strong>Tables</strong>
    </el-divider>

    <br>
    <!-- <div v-for="(item2, index) in this.slice(this.tables,2)" :key="index"> -->
    <div v-for="(item2, index) in sliceTablesBy2" :key="index+tables.key">
      <el-row>
          <el-col v-for="(item, index) in item2" :key="index" style="text-align: center;" :span="12">
            <TableCrad :coffee_shop='coffee_shop' :event='event' :table='item' 
            @onDeleteTable="removeTableFromList"
            @onUpdateTable="updateTable"
            :editAble="current_user && EDIT_ABLE" :reActiveAble="current_user && RE_ACTIVE_ABLE" :deleteAble="current_user && DELETE_ABLE"/>
          </el-col>
      </el-row>
    </div>

    <AddTableDailog v-if="add" :coffee_shop_id='coffee_shop_id'
      :event_id='id' :dialogFormVisible.sync='add' :tables="tables.data"
      @onTableAdded="callGET_CoofeeShopEventTables"
    />

    <UpdateTableDailog v-if="update" :coffee_shop_id='coffee_shop_id'
      :event_id='id' :id='updateing_table_id' :dialogFormVisible.sync='update' :tables="tables.data"
      @onTableUpdated="callGET_CoofeeShopEventTables"
    />
  </div>
</template>

<script>
import route_helpers from '../../services/route_helpers'
import router from '../../packs/router'
import TableCrad from '../../components/tables/components/table_card'
import AddTableDailog from '../../components/tables/components/add_table_dailog'
import UpdateTableDailog from '../../components/tables/components/update_table_dailog'

export default {
  props: ['coffee_shop_id' ,'id'],
  data: function () {
    return {
      current_user:{},
      event:{},
      coffee_shop:{},
      tables:{
        key:"",
        data:[]
      },
      updateing_table_id: null,
      add: false,
      update: false,
      load: true,
    }
  },
  components:{
    TableCrad,
    AddTableDailog,
    UpdateTableDailog
  },
  methods:{
    slice (array,len) {
      let reslut = []
      let count = Math.ceil(array.length / len)
      for (let i= 0; i< count; i++) {
        reslut.push(array.slice(i* len, i* len + len))
      }
      return reslut
    },
    callGET_CoffeeShopEvent(){
      console.log("callGET_CoffeeShopEvent")
      this.load = false;
      route_helpers.GET().coffee_shop_event(this.coffee_shop_id, this.id)
      .then(response => {this.tempName(response.data);})
      .then(() => {this.load = true})
    },
    callGET_CoofeeShopEventTables(){
      console.log("callGET_CoofeeShopEventTables")
      route_helpers.GET().coffee_shop_event_tables(this.coffee_shop_id, this.id)
      .then(response => {
        this.tables.data = response.data.data
        this.tables.key = Math.random();
        })
    },
    removeTableFromList(id){
      for(var i = 0; i < this.tables.data.length; i++){ 
        if (this.tables.data[i].id === id) {
          this.tables.data.splice(i, 1); 
        }
      }
    },
    updateTable(table_id){
      console.log("updateTable")
      this.updateing_table_id = table_id
      this.update = !this.update
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
    },
    isMaintainer(){
      return this.current_user !== null && 
             this.current_user.attributes.role === "sys_expert" &&
             this.coffee_shop.relationships.maintainer.data.id === this.current_user.id
    },
    isOwner(){
      return this.current_user !== null && 
             this.current_user.attributes.role === "coffee_owner" &&
             this.coffee_shop.relationships.owner.data.id === this.current_user.id
    },
    
  },
  computed:{
    sliceTablesBy2() {
      let reslut = []
      let count = Math.ceil(this.tables.data.length / 2)
      for (let i= 0; i< count; i++) {
        reslut.push(this.tables.data.slice(i* 2, i* 2 + 2))
      }
      return reslut
    },
    uperCaseStatus(){
      return this.event.attributes.status[0].toUpperCase()+ this.event.attributes.status.substr(1);
    },
    CREAT_TABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
    },
    CHECK_EVENT_STATUS(){
      return this.event.attributes.status !== "ended" &&
            this.event.attributes.status !== "closed"
    },
    EDIT_ABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
    },
    RE_ACTIVE_ABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master"
    },
    DELETE_ABLE(){
      return this.current_user.attributes.role === "sys_admin" ||
          this.current_user.attributes.role === "sys_master" ||
          this.isMaintainer() ||
          this.isOwner()
    },
  },
  created(){
    console.log("evnevts#show.created")
    this.$store.dispatch('updatePageHeader', 'Event Show')

    this.$store.watch(
      (state, getters) => getters.current_user,
      (newValue, oldValue) => {
        console.log(`Updating from ${oldValue} to ${newValue}`);
        this.current_user = this.$store.state.current_user
      }
    );
    this.current_user = this.$store.state.current_user

    this.callGET_CoffeeShopEvent()
    this.callGET_CoofeeShopEventTables()
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
