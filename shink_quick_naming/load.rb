$LOAD_PATH.unshift(File.dirname(__FILE__))

load('shink_sketchup_library/load.rb')#加载基础库
SHINK_LIBRARY.inject_to_module(ShinkQuickNaming)#注入到模块

Sketchup::require('path')#路径相关方法
Sketchup::require('db')#数据定义
Sketchup::require('main')#按钮菜单定义
Sketchup::require('browser')#对话框定义
