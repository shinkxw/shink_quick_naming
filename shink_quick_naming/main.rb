module ShinkQuickNaming
  module Main
    module_function

    def show_quick_naming_dialog
      if check_browser
        @quick_naming_dialog ||= Browser.new("快速命名分层", 'quick_naming')
        @quick_naming_dialog.show
      end
    end

    def show_plugin_settings_dialog
      if check_browser
        @plugin_settings_dialog ||= Browser.new("插件设置", 'plugin_settings')
        @plugin_settings_dialog.show
      end
    end

    def check_browser
      if ShinkQuickNaming.const_defined?(:IEVersion) && IEVersion < 9
        UI.messagebox('您的浏览器版本过低, 请至少升级至IE9')
        false
      else
        true
      end
    end
  end

  unless file_loaded?(__FILE__)#保证代码块中代码只执行一次
    toolbar = UI.toolbar(PluginName)#创建工具栏

    cmd1 = UI::Command.new("Show Quick Naming Dialog") {
      Main.show_quick_naming_dialog
    }
    cmd1.small_icon = small_icon_path('quick_naming')#设置小图标
    cmd1.large_icon = large_icon_path('quick_naming')#设置大图标
    cmd1.tooltip = '快速命名分层'#设置提示文字
    toolbar = toolbar.add_item(cmd1)#添加按钮

    cmd99 = UI::Command.new("Show Plugin Settings Dialog") {
      Main.show_plugin_settings_dialog
    }
    cmd99.small_icon = small_icon_path('plugin_settings')
    cmd99.large_icon = large_icon_path('plugin_settings')
    cmd99.tooltip = '插件设置'
    toolbar = toolbar.add_item(cmd99)

    toolbar.show#显示工具栏

    file_loaded(__FILE__)
  end
end
