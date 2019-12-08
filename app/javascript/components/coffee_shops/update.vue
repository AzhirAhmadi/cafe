<template>
  <el-form :model="coffee_shop.attributes" :rules="rules" ref="updateCoffeeShop" label-width="150px ">
    
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
export default {
  props:['id'],
  data(){
    return {
      coffee_shop:{
        attributes:{
          name: "",
          address: "",
          owner_id: null,
          maintainer_id: null
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
    callCoffeeShopUpdate(){
      console.log("callCoffeeShopUpdate")
      this.$coffeeShopResource.PUT_coffee_shop(this.id,this.coffee_shop.attributes)
      .then((response)=> {console.log(response)})
      .then(()=>{this.$router.go(-1)})
    },
    callUsers(){
      console.log("callUsers")
       this.$userResource.GET_users("?role=coffee_owner&free=true")
       .then(response => {this.owners = response.data.data})
       this.$userResource.GET_users("?role=sys_expert")
       .then(response => {this.maintainers = response.data.data})
    },
    callGET_coffee_shop(){
      this.$coffeeShopResource.GET_coffee_shop(this.id)
      .then((response)=>{ this.set_coofee_shop_data(response.data.data)})
    },
    set_coofee_shop_data(data){
      console.log(data)
      console.log(data.relationships.owner.data.id)
      this.coffee_shop.attributes.name = data.attributes.name
      this.coffee_shop.attributes.address = data.attributes.address
      this.coffee_shop.attributes.owner_id = data.relationships.owner.data.id
      this.coffee_shop.attributes.maintainer_id = data.relationships.maintainer.data.id
      
      this.$userResource.GET_user(this.coffee_shop.attributes.owner_id)
      .then(response => {this.owners.push(response.data.data)})
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.callCoffeeShopUpdate()
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
    this.callUsers();
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
