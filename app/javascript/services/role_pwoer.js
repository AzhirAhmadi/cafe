export default {
    power(role){
        if(role == "sys_master"){
            return 5;
        }
        else if(role == "sys_admin"){
            return 4;
        }
        else if(role == "sys_expert"){
            return 3;
        }
        else if(role == "coffee_owner"){
            return 2;
        }
        else if(role == "player"){
            return 1;
        }
    },
    LT(role1 ,role2){
        if(this.power(role1) < this.power(role2)){
            return true;
        }
        return false;
    },
    EQ(role1 ,role2){
        if(this.power(role1) == this.power(role2)){
            return true;
        }
        return false;
    },
    GT(role1 ,role2){
        if(this.power(role1) > this.power(role2)){
            return true;
        }
        return false;
    }
}