import router from '../packs/router'

export default {
    _401(data){
        console.log("_401(data)")
        router.push('/sing_in')
    }
}