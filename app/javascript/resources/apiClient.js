import axios from 'axios'

const apiClient = axios.create({
    baseURL: 'https://cafe-emecenter.herokuapp.com/api',
    withCredentials: false,
    headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
    }
})

export default apiClient