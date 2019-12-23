<template>
  <el-form v-if="load" :model="coffee_shop.attributes" :rules="rules" ref="updateCoffeeShop" label-width="150px ">
    
    <el-form-item>
      <Uploader @onImageChange="setImage" :image="coffee_shop.attributes.avatar"/>
    </el-form-item>

    <el-form-item label="Name" prop="name" required>
      <el-input v-model="coffee_shop.attributes.name"></el-input>
    </el-form-item>
    
    <el-form-item label="Address" prop="address" required>
      <el-input v-model="coffee_shop.attributes.address"></el-input>
    </el-form-item>

    <el-form-item  v-if="EDIT_OWNER" label="Owner" prop="owner_id"> 
      <el-select v-model="coffee_shop.attributes.owner_id" placeholder="Select">
        <el-option
          v-for="item in owners"
          :key="item.attributes.id"
          :label="item.attributes.email"
          :value="item.id">
        </el-option>
      </el-select>
    </el-form-item>

    <el-form-item v-if="EDIT_MAINTAINER" label="Maintainer" prop="maintainer_id"> 
      <el-select v-model="coffee_shop.attributes.maintainer_id" placeholder="Select">
        <el-option
          v-for="item in maintainers"
          :key="item.attributes.id"
          :label="item.attributes.email"
          :value="item.id">
        </el-option>
      </el-select>
    </el-form-item>

    <el-form-item>
      <el-button type="success" @click="submitForm('updateCoffeeShop')">Save</el-button>
      <el-button type="warning" @click="resetForm('updateCoffeeShop')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import Uploader from '../shard/singleImageUploader'
export default {
  props:['id'],
  data(){
    return {
      load: true,
      coffee_shop:{
        attributes:{
          name: "",
          address: "",
          owner_id: null,
          maintainer_id: null,
          image: null,
        }
      },
      owners:[],
      maintainers: [],
      rules: {
        name: [
          { required: true, message: 'Please input name', trigger: 'change' },
          { min: 5, max: 11, message: 'Length should be 5 to 10', trigger: 'blur' }
        ],
        address: [
          { required: true, message: 'Please input address', trigger: 'change' },
        ],
        owner_id: [
          { required: true, message: 'Please select owner', trigger: 'change' },
        ],
        maintainer_id: [
          { required: true, message: 'Please select maintainer', trigger: 'change' },
        ],
      },
    }
  },
  methods:{
    callPUT_CoffeeShopUpdate(){
      console.log("callPUT_CoffeeShopUpdate")
      this.$coffeeShopResource.PUT_coffee_shop(this.id,this.coffee_shop.attributes)
      .then((response)=> {console.log(response)})
      .then(()=>{this.$router.go(-1)})
    },
    callGET_Users(){
      console.log("callGET_Users")
       this.$userResource.GET_users("?role=coffee_owner&free=true")
       .then(response => {this.owners = response.data.data})
       this.$userResource.GET_users("?role=sys_expert")
       .then(response => {this.maintainers = response.data.data})
    },
    callGET_coffee_shop(){
      this.load = false
      this.$coffeeShopResource.GET_coffee_shop(this.id)
      .then((response)=>{ this.set_coofee_shop_data(response.data.data)})
      .then(() => {this.load = true})
    },
    set_coofee_shop_data(data){
      console.log(data)
      console.log(data.relationships.owner.data.id)
      this.coffee_shop.attributes.name = data.attributes.name
      this.coffee_shop.attributes.address = data.attributes.address
      this.coffee_shop.attributes.avatar = data.attributes.avatar

      this.coffee_shop.attributes.owner_id = data.relationships.owner.data.id
      this.coffee_shop.attributes.maintainer_id = data.relationships.maintainer.data.id

      this.$userResource.GET_user(this.coffee_shop.attributes.owner_id)
      .then(response => {this.owners.push(response.data.data)})
    },
    setImage(file){
      this.coffee_shop.attributes.image = file.raw
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.callPUT_CoffeeShopUpdate()
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
  components:{
    Uploader,
  },
  computed:{
    SELECT_ROLE(){
      return this.current_user !== null && this.current_user.attributes.role !== "player"
    },
    current_user(){
      return this.$store.state.current_user
    },
    EDIT_OWNER(){
      console.log("EDIT_OWNER")
      console.log()
      return this.current_user.attributes.role === 'sys_admin' || this.current_user.role === 'sys_master'
    },
    EDIT_MAINTAINER(){
      console.log("EDIT_MAINTAINER")
      console.log()
      return this.current_user.attributes.role === 'sys_admin' || this.current_user.role === 'sys_master'
    }
  },
  created(){
    console.log("coffee_shops#create.created")
    this.$store.dispatch('updatePageHeader', 'Update CoffeeShop');
    this.callGET_Users();
    this.callGET_coffee_shop();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
