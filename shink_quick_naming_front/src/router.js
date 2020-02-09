import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

let route_config = [
  { path: '/quick_naming', component: require('v/quick_naming') },
  { path: '/plugin_settings', component: require('v/plugin_settings/layout'),
    children: [
      { path: 'layer_setting', component: require('v/plugin_settings/layer_setting') },
      { path: 'naming_setting', component: require('v/plugin_settings/naming_setting') }
    ]
  }
]

function parseQuery (query) {
  var res = {};
  query = query.trim().replace(/^(\?|#|&)/, '');

  if (!query) {
    return res
  }

  query.split('&').forEach(function (param) {
    var parts = param.replace(/\+/g, ' ').split('=');
    var key = decodeURIComponent(parts.shift());
    var val = parts.length > 0
      ? decodeURIComponent(parts.join('='))
      : null;

    if(/^-?\d+$/.test(val)) { val = parseInt(val) }//数字转换

    if (res[key] === undefined) {
      res[key] = val;
    } else if (Array.isArray(res[key])) {
      res[key].push(val);
    } else {
      res[key] = [res[key], val];
    }
  });

  return res
}

let router = new Router({ routes: route_config, parseQuery: parseQuery })
router.beforeEach((to, from, next) => { to.path == '/' ? next(false) : next() })//修复IE9下跳转至根链接的bug

export default router
