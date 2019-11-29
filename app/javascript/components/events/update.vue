<template>
  <el-form :model="temp_event" :rules="rules" ref="createEvent" label-width="150px">
    
    <el-form-item label="Event name" prop="name" required>
      <el-input v-model="temp_event.name"></el-input>
    </el-form-item>

    <el-form-item label="Event description" prop="description" required>
      <el-input type="textarea" v-model="temp_event.description"></el-input>
    </el-form-item>
    
    <el-form-item label="Open time" required>
      <el-col :span="11">
        <el-form-item prop="opens_at_date">
          <el-date-picker type="date" placeholder="Pick a date" v-model="temp_event.opens_at_date" style="width: 100%;"></el-date-picker>
        </el-form-item>
      </el-col>

      <el-col class="line" :span="2">-</el-col>

      <el-col :span="11">
        <el-form-item prop="opens_at_time">
          <el-time-picker placeholder="Pick a time" v-model="temp_event.opens_at_time" style="width: 100%;"></el-time-picker>
        </el-form-item>
      </el-col>
    </el-form-item>

    <el-form-item label="Enrolment start time" required>
      <el-col :span="11">
        <el-form-item prop="enrol_start_date">
          <el-date-picker type="date" placeholder="Pick a date" v-model="temp_event.enrol_start_date" style="width: 100%;"></el-date-picker>
        </el-form-item>
      </el-col>

      <el-col class="line" :span="2">-</el-col>

      <el-col :span="11">
        <el-form-item prop="enrol_start_time">
          <el-time-picker placeholder="Pick a time" v-model="temp_event.enrol_start_time" style="width: 100%;"></el-time-picker>
        </el-form-item>
      </el-col>
    </el-form-item>

    <el-form-item label="Enrolment end time" required>
      <el-col :span="11">
        <el-form-item prop="enrol_end_date">
          <el-date-picker type="date" placeholder="Pick a date" v-model="temp_event.enrol_end_date" style="width: 100%;"></el-date-picker>
        </el-form-item>
      </el-col>

      <el-col class="line" :span="2">-</el-col>

      <el-col :span="11">
        <el-form-item prop="enrol_end_time">
          <el-time-picker placeholder="Pick a time" v-model="temp_event.enrol_end_time" style="width: 100%;"></el-time-picker>
        </el-form-item>
      </el-col>
    </el-form-item>

    <el-form-item label="Event start time" required>
      <el-col :span="11">
        <el-form-item prop="event_start_date">
          <el-date-picker type="date" placeholder="Pick a date" v-model="temp_event.event_start_date" style="width: 100%;"></el-date-picker>
        </el-form-item>
      </el-col>

      <el-col class="line" :span="2">-</el-col>

      <el-col :span="11">
        <el-form-item prop="event_start_time">
          <el-time-picker placeholder="Pick a time" v-model="temp_event.event_start_time" style="width: 100%;"></el-time-picker>
        </el-form-item>
      </el-col>
    </el-form-item>

    <el-form-item label="Event end time" required>
      <el-col :span="11">
        <el-form-item prop="event_end_date">
          <el-date-picker type="date" placeholder="Pick a date" v-model="temp_event.event_end_date" style="width: 100%;"></el-date-picker>
        </el-form-item>
      </el-col>

      <el-col class="line" :span="2">-</el-col>

      <el-col :span="11">
        <el-form-item prop="event_end_time">
          <el-time-picker placeholder="Pick a time" v-model="temp_event.event_end_time" style="width: 100%;"></el-time-picker>
        </el-form-item>
      </el-col>
    </el-form-item>

    <el-form-item label="Close Time" required>
      <el-col :span="11">
        <el-form-item prop="closed_at_date">
          <el-date-picker type="date" placeholder="Pick a date" v-model="temp_event.closed_at_date" style="width: 100%;"></el-date-picker>
        </el-form-item>
      </el-col>

      <el-col class="line" :span="2">-</el-col>

      <el-col :span="11">
        <el-form-item prop="closed_at_time">
          <el-time-picker placeholder="Pick a time" v-model="temp_event.closed_at_time" style="width: 100%;"></el-time-picker>
        </el-form-item>
      </el-col>
    </el-form-item>

    <el-form-item>
      <el-button type="success" @click="submitForm('createEvent')">Save</el-button>
      <el-button type="warning" @click="resetForm('createEvent')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import route_helpers from '../../services/route_helpers'
import error_handler from '../../services/error_handler'

export default {
  props:['coffee_shop_id', 'id'],
  data(){
    var check_enrol_start_date = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the date'));
      } else {
        if( this.compareDates(value ,this.temp_event.opens_at_date) === -1){
          callback(new Error('Please input the correct date'));
        }
        callback();
      }
    };

    var check_enrol_start_time = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the time'));
      } else {
        if(this.compareDates(this.temp_event.enrol_start_date, this.temp_event.opens_at_date) === 0 ){
          if(value < this.temp_event.opens_at_time){
            callback(new Error('Please input the correct time'));
          }
        }
        callback();
      }
    };

    var check_enrol_end_date = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the date'));
      } else {
        if( this.compareDates(value ,this.temp_event.enrol_start_date) === -1){
          callback(new Error('Please input the correct date'));
        }
        callback();
      }
    };

    var check_enrol_end_time = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the time'));
      } else {
        if(this.compareDates(this.temp_event.enrol_end_date, this.temp_event.enrol_start_date) === 0 ){
          if(value < this.temp_event.enrol_start_time){
            callback(new Error('Please input the correct time'));
          }
        }
        callback();
      }
    };

    var check_event_start_date = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the date'));
      } else {
        if( this.compareDates(value ,this.temp_event.enrol_end_date) === -1){
          callback(new Error('Please input the correct date'));
        }
        callback();
      }
    };

    var check_event_start_time = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the time'));
      } else {
        if(this.compareDates(this.temp_event.event_start_date, this.temp_event.enrol_end_date) === 0 ){
          if(value < this.temp_event.enrol_end_time){
            callback(new Error('Please input the correct time'));
          }
        }
        callback();
      }
    };

    var check_event_end_date = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the date'));
      } else {
        if( this.compareDates(value ,this.temp_event.event_start_date) === -1){
          callback(new Error('Please input the correct date'));
        }
        callback();
      }
    };

    var check_event_end_time = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the time'));
      } else {
        if(this.compareDates(this.temp_event.event_end_date, this.temp_event.event_start_date) === 0 ){
          if(value < this.temp_event.event_start_time){
            callback(new Error('Please input the correct time'));
          }
        }
        callback();
      }
    };

    var check_closed_at_date = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the date'));
      } else {
        if( this.compareDates(value ,this.temp_event.event_end_date) === -1){
          callback(new Error('Please input the correct date'));
        }
        callback();
      }
    };

    var check_closed_at_time = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please select the time'));
      } else {
        if(this.compareDates(this.temp_event.closed_at_date, this.temp_event.event_end_date) === 0 ){
          if(value < this.temp_event.event_end_time){
            callback(new Error('Please input the correct time'));
          }
        }
        callback();
      }
    };
  
    return {
      event:{
        attributes:{
          name:"",
          description:"",
          opens_at:null,
          enrol_start_time:null,
          enrol_end_time:null,
          event_start_time:null,
          event_end_time:null,
          closed_at: null
        }
      },
      temp_event:{
        name: "",
        description:"",

        opens_at_date:null,
        opens_at_time:null,
        
        enrol_start_date:null,
        enrol_start_time:null,

        enrol_end_date:null,
        enrol_end_time:null,

        event_start_date:null,
        event_start_time:null,

        event_end_date:null,
        event_end_time:null,

        closed_at_date:null,
        closed_at_time:null,
      },
      rules: {
        name: [
          { required: true, message: 'Please input event name', trigger: 'blur' },
          { min: 5, max: 10, message: 'Length should be 5 to 10', trigger: 'blur' }
        ],
        description:[
          { required: true, message: 'Please input event description', trigger: 'blur' }
        ],
        opens_at_date: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' }
        ],
        opens_at_time: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' }
        ],

        enrol_start_date: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' },
          { validator: check_enrol_start_date, trigger: 'change' }
        ],
        enrol_start_time: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' },
          { validator: check_enrol_start_time, trigger: 'change' }
        ],

        enrol_end_date: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' },
          { validator: check_enrol_end_date, trigger: 'change' }
        ],
        enrol_end_time: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' },
          { validator: check_enrol_end_time, trigger: 'change' }
        ],

        event_start_date: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' },
          { validator: check_event_start_date, trigger: 'change' }
        ],
        event_start_time: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' },
          { validator: check_event_start_time, trigger: 'change' }
        ],

        event_end_date: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' },
          { validator: check_event_end_date, trigger: 'change' }
        ],
        event_end_time: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' },
          { validator: check_event_end_time, trigger: 'change' }
        ],

        closed_at_date: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' },
          { validator: check_closed_at_date, trigger: 'change' }
        ],
        closed_at_time: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' },
          { validator: check_closed_at_time, trigger: 'change' }
        ]
      }
    }
  },
  methods:{
    setEventData(){
      this.setTime(this.temp_event.opens_at_date, this.temp_event.opens_at_time)
      this.setTime(this.temp_event.enrol_start_date, this.temp_event.enrol_start_time)
      this.setTime(this.temp_event.enrol_end_date, this.temp_event.enrol_end_time)
      this.setTime(this.temp_event.event_start_date, this.temp_event.event_start_time)
      this.setTime(this.temp_event.event_end_date, this.temp_event.event_end_time)
      this.setTime(this.temp_event.closed_at_date, this.temp_event.closed_at_time)

      this.event.attributes.opens_at = this.temp_event.opens_at_date
      this.event.attributes.enrol_start_time = this.temp_event.enrol_start_date
      this.event.attributes.enrol_end_time = this.temp_event.enrol_end_date
      this.event.attributes.event_start_time = this.temp_event.event_start_date
      this.event.attributes.event_end_time = this.temp_event.event_end_date
      this.event.attributes.closed_at = this.temp_event.closed_at_date

      this.event.attributes.name = this.temp_event.name
      this.event.attributes.description = this.temp_event.description

      this.callPUT_coffee_shop_event()
    },
    setTime(date , time){
      date.setHours(
        time.getHours(),
        time.getMinutes(),
        time.getSeconds())
    },
    setData(data){
      this.event.attributes = data.attributes

      this.temp_event.name = this.event.attributes.name
      this.temp_event.description = this.event.attributes.description

      this.event.attributes.opens_at = new Date(this.event.attributes.opens_at)
      this.event.attributes.enrol_start_time = new Date(this.event.attributes.enrol_start_time)
      this.event.attributes.enrol_end_time = new Date(this.event.attributes.enrol_end_time)
      this.event.attributes.event_start_time = new Date(this.event.attributes.event_start_time)
      this.event.attributes.event_end_time = new Date(this.event.attributes.event_end_time)
      this.event.attributes.closed_at = new Date(this.event.attributes.closed_at)

      this.temp_event.opens_at_date = this.event.attributes.opens_at
      this.temp_event.enrol_start_date = this.event.attributes.enrol_start_time
      this.temp_event.enrol_end_date = this.event.attributes.enrol_end_time
      this.temp_event.event_start_date = this.event.attributes.event_start_time
      this.temp_event.event_end_date = this.event.attributes.event_end_time
      this.temp_event.closed_at_date = this.event.attributes.closed_at

      this.temp_event.opens_at_time = this.event.attributes.opens_at
      this.temp_event.enrol_start_time = this.event.attributes.enrol_start_time
      this.temp_event.enrol_end_time = this.event.attributes.enrol_end_time
      this.temp_event.event_start_time = this.event.attributes.event_start_time
      this.temp_event.event_end_time = this.event.attributes.event_end_time
      this.temp_event.closed_at_time = this.event.attributes.closed_at
    },
    callGET_coffee_shop_event(){
      route_helpers.GET().coffee_shop_event(this.coffee_shop_id, this.id)
      .then((response) => { this.setData(response.data.data)})
    },
    callPUT_coffee_shop_event(){
      console.log("callCoffeeShopCreate")
      route_helpers.PUT().coffee_shop_event(this.coffee_shop_id, this.id, this.event.attributes)
      .then(()=>{this.$router.go(-1)})
      .catch(error => {error_handler._401("get#users")})
    },
    compareDates(d1 , d2){
      if(d1.getFullYear() < d2.getFullYear()){
        return -1;
      }
      if(d1.getFullYear() > d2.getFullYear()){
        return 1;
      }
      if(d1.getFullYear() === d2.getFullYear()){
        if(d1.getMonth() < d2.getMonth()){
          return -1;
        }
        if(d1.getMonth() > d2.getMonth()){
          return 1;
        }
        if(d1.getMonth() === d2.getMonth()){
          if(d1.getDate() < d2.getDate()){
          return -1;
          }
          if(d1.getDate() > d2.getDate()){
            return 1;
          }
          if(d1.getDate() === d2.getDate()){
            return 0;
          }
        }
      }
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.setEventData();
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
    SELECT_ROLE(){
      return this.current_user !== null && this.current_user.attributes.role !== "player"
    },
    current_user(){
      return this.$store.state.current_user
    }
  },
  created(){
    console.log("events#uppdate.created")
    this.$store.dispatch('updatePageHeader', 'Create Event');
    this.callGET_coffee_shop_event();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
