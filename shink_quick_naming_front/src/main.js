import 'es6-promise/auto'
import Vue from 'vue'
import router from './router'
import ComponentsMap from './components'
import axios from 'axios'
import $ from 'jquery'
import 'bootstrap/dist/css/bootstrap.min.css'//引入bootstrap样式
import 'bootstrap/dist/js/bootstrap.min'
import './assets/stylesheets/index.css'//引入全局样式
import './assets/javascripts/global_function'//引入全局方法
window.zlib = require('zlib')

window.Vue = Vue

Vue.config.productionTip = false

window.router = router

//axios设置
window.axios = axios
axios.defaults.baseURL = 'http://localhost:38586'
axios.interceptors.request.use(function (config) {
  if (!config.params) {
    config.params = {}
  }
  config.params.time = new Date().getTime()//添加时间戳防止请求被浏览器缓存
  return config;
}, function (error) {
  return Promise.reject(error);
})

axios.interceptors.response.use((res) => {
  return res;
}, (error) => {//错误信息处理
  if (error.response) {
    if (typeof(error.response.data) == 'string') {
      su_alert(error.response.data)
    }
    else {
      return Promise.reject(error);
    }
  } else {
    su_alert(error.message)
  }
})

ComponentsMap(Vue)//加载组件
prevent_f5()//禁止页面使用F5刷新
prevent_backspace()//禁止页面回退
$(window).resize(function() {
  cal_and_set_css()//当窗口大小变化时调用
})
new Vue({ el: '#app', router })//根组件实例化
if(getQueryString('type')){router.push(getQueryString('type'))}//跳转网址
