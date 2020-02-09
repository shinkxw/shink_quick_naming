module ShinkQuickNaming
  class Browser < ShinkBrowser
    def initialize(title, type)
      @type = type
      super(title, true, type, 0, 0, 500, 150, true)
      set_background_color(get_default_dialog_color)
      set_callback
    end

    def set_callback
      add_callback("alert"){|d, param| UI.messagebox(param.message)}
    end

    def show
      if visible?
        bring_to_front
      else
        set_url(index_path)
        set_window_min_size_by_type
        LocalServer.add_user("#{@type}_dialog")#使用复用服务
        after_close{ LocalServer.delete_user("#{@type}_dialog") }#注册关闭事件
        SuRunJs.set_web_dialog(@type, self)#将窗口类型与窗口实例绑定
        case @type
        when 'quick_naming'
          RefreshEntityObserver.open(@type) do#设置选中对象改变时调用的代码
            run_js(@type, "quick_naming.refresh_entity_info()")
          end
          after_close{ RefreshEntityObserver.close(@type) }#设置窗口关闭时调用的代码
        end
        super
      end
    end

    def set_window_min_size_by_type
      case @type
      when 'quick_naming'
        set_window_min_size(500, 460)
      when 'plugin_settings'
        set_window_min_size(1200, 670)
      end
    end

    def index_path
      ShinkQuickNaming.local_page_path(@type)
    end
  end

  class RefreshEntityObserver < Sketchup::SelectionObserver
    def self.open(type, &block)
      @type_observer_hash ||= {}
      observer = RefreshEntityObserver.new(&block)
      @type_observer_hash[type] = observer
      Sketchup.active_model.selection.add_observer(observer)
      ModelChangeObserver.open(type){ RefreshEntityObserver.open(type, &block) }
    end

    def self.close(type)
      if @type_observer_hash[type]
        Sketchup.active_model.selection.remove_observer(@type_observer_hash[type])
        @type_observer_hash[type] = nil
        ModelChangeObserver.close(type)
      end
    end

    def initialize(&block);@block = block end
    def onSelectionBulkChange(selection);@block.call end
    def onSelectionCleared(selection);@block.call end
  end

  class ModelChangeObserver < Sketchup::AppObserver
    def self.open(type, &block)
      @type_observer_hash ||= {}
      if @type_observer_hash[type].nil?
        observer = ModelChangeObserver.new(&block)
        @type_observer_hash[type] = observer
        Sketchup.add_observer(observer)
      end
    end

    def self.close(type)
      if @type_observer_hash[type]
        Sketchup.remove_observer(@type_observer_hash[type])
        @type_observer_hash[type] = nil
      end
    end

    def initialize(&block);@block = block end
    def onNewModel(model);@block.call end
    def onOpenModel(model);@block.call end
  end
end
