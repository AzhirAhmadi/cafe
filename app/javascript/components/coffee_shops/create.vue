<template>
  <el-form :model="coffee_shop.attributes" :rules="rules" ref="createCoffeeShop" label-width="150px ">
    
    <el-form-item label="Name" prop="name" required>
      <el-input v-model="coffee_shop.attributes.name"></el-input>
    </el-form-item>
    
    <el-form-item label="Address" prop="address" required>
      <el-input v-model="coffee_shop.attributes.address"></el-input>
    </el-form-item>

    <el-form-item label="Owner" prop="owner_id"> 
      <el-select v-model="coffee_shop.attributes.owner_id" placeholder="Select">
        <el-option
          v-for="item in owners"
          :key="item.attributes.id"
          :label="item.attributes.email"
          :value="item.id">
        </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Maintainer" prop="maintainer_id"> 
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
      <el-button type="success" @click="submitForm('createCoffeeShop')">Create</el-button>
      <el-button type="warning" @click="resetForm('createCoffeeShop')">Reset</el-button>
      <el-button type="danger" @click="cancel">Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import route_helpers from '../../services/route_helpers'

export default {
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
    callCoffeeShopCreate(){
      console.log("callCoffeeShopCreate")
      route_helpers.POST().coffee_shops(this.coffee_shop.attributes)
      .then((response)=> {console.log(response)})
      .then(()=>{this.$router.go(-1)})
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    callUsers(){
      console.log("callUsers")
       route_helpers.GET().users("?role=coffee_owner&free=true")
       .then(response => {this.owners = response.data.data})
       route_helpers.GET().users("?role=sys_expert")
       .then(response => {this.maintainers = response.data.data})
    },
    cancel(){
      console.log("cancel")
      this.$router.go(-1)
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.callCoffeeShopCreate()
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
    }
  },
  created(){
    console.log("coffee_shops#create.created")
    this.$store.dispatch('updatePageHeader', 'Create CoffeeShop');
    this.callUsers();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
