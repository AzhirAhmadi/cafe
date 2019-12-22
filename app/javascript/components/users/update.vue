<template>
    <el-form :model="user.attributes" :rules="rules" ref="createUser" label-width="150px ">
    
    <el-form-item>
      <Uploader @onImageChange="setImage" :image="user.attributes.avatar.image"/>
    </el-form-item>

    <el-form-item label="Email" prop="email" required>
      <el-input v-model="user.attributes.email"></el-input>
    </el-form-item>
    
    <el-form-item label="Password" prop="password" required autocomplete="off">
      <el-input  v-model="user.attributes.password" clearable/>
    </el-form-item>

    <el-form-item label="Confirm" prop="confirm" autocomplete="off">
      <el-input  v-model="user.attributes.confirm" clearable/>
    </el-form-item>

    <el-form-item v-if="SELECT_ROLE" label="Role" prop="role"> 
      <el-select v-model="user.attributes.role" placeholder="Select">
        <el-option
          v-for="item in roles"
          :key="item.value"
          :label="item.label"
          :value="item.value">
        </el-option>
      </el-select>
    </el-form-item>

    <el-form-item>
      <el-button type="success" @click="submitForm('createUser')">Save</el-button>
      <el-button type="warning" @click="resetForm('createUser')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import router from '../../packs/router'
import Uploader from '../shard/singleImageUploader'

export default {
  props:['id'],
  data(){
    var validateConfirm = (rule, value, callback) => {
      console.log("validateConfirm")
      console.log(value)
      if (value === '') {
        callback(new Error('Please input the password again'));
      } else if (value !== this.user.attributes.password) {
        callback(new Error('Two inputs don\'t match!'));
      } else {
        callback();
      }
    };
    return {
      user:{
        attributes:{
          email:"",
          password: "",
          role: "player",
          confirm: "",
          image: null
        }
      },
      roles:[
        {
          label: 'player',
          value: 'player'
        },
        {
          label: 'coffee_owner',
          value: 'coffee_owner'
        },
        {
          label: 'sys_expert',
          value: 'sys_expert'
        },
        {
          label: 'sys_admin',
          value: 'sys_admin'
        },
        {
          label: 'sys_master',
          value: 'sys_master'
        },
      ],
      rules: {
          email: [
            { required: true, message: 'Please input email', trigger: 'change' },
            { type: 'email', message: 'Please input correct email address', trigger: ['blur', 'change'] },
          ],
          password: [
            { required: true, message: 'Please input password', trigger: 'change' },
            { min: 6, message: 'Length should more then 6', trigger: 'blur' }
          ],
          confirm: [
            { validator: validateConfirm, trigger: 'blur' }
          ],
          role: [
            { required: true, message: 'Please select role', trigger: 'change' },
          ],
      },
    }
  },
  components:{
    Uploader,
  },
  methods:{
    callUserUpdate(){
      console.log("callUserUpdate")
      this.$userResource.PUT_user(this.id,this.user.attributes)
      .then(()=>{this.$router.go(-1)})
    },
    callGET_User(){
      console.log("callUsers")
       this.$userResource.GET_user(this.id)
       .then(response => {this.user = response.data.data})
    },
    setImage(file){
      this.user.attributes.image = file.raw
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.callUserUpdate()
          alert('submit!');
        } else {
          alert('error submit!!');
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
      console.log(this.current_user !== null)
      console.log(this.current_user.role !== "player")
      console.log(this.current_user.role)
      return this.current_user !== null && this.current_user.attributes.role !== "player"
    },
    current_user(){
      return this.$store.state.current_user
    }
  },
  created(){
    console.log("users#update.created")
    this.$store.dispatch('updatePageHeader', 'Update User')
    this.callGET_User()
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>