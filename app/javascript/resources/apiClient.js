import axios from 'axios'

const apiClient = axios.create({
    baseURL: 'http://emecenter.ir/api',
    withCredentials: false,
    headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
    }
})

export default apiClient