module ShinkQuickNaming
  module UnifiedDataOperationInterface
    module_function

    def operate_arr(params)
      source = params.udoi_source#数据范围
      type = params.udoi_type#操作类型
      arr = get_arr(source, params)#数据数组
      redult = case type
      when 'data'#数组数据
        arr
      when 'import'#导入
        import_data(source, arr)
      when 'export'#导出
        export_data_to_json(source, arr)
      when 'init'#初始化
        confirm_init_data(source, arr)
      when 'add'#添加元素至数组末尾
        get_new_obj(source, params).tap{|o| arr << o}.to_h
      when 'add_by_index'#添加元素至数组指定位置
        get_new_obj(source, params).tap{|o| arr.insert(params.index.to_i, o)}.to_h
      when 'up'#上移指定元素
        i = arr.find_index{|o| o['id'] == params.id}
        if i && i > 0
          arr[i], arr[i-1] = arr[i-1], arr[i]
        end
      when 'down'#下移指定元素
        i = arr.find_index{|o| o['id'] == params.id}
        if i && i < arr.length - 1
          arr[i], arr[i+1] = arr[i+1], arr[i]
        end
      when 'remove'#删除指定元素
        arr.delete_if{|o| o['id'] == params.id}
      when 'change_value'#修改指定元素的值
        if obj = arr.find{|o| o['id'] == params.id}
          obj[params.key] = params.value
          arr.save if arr.respond_to?(:save)
        end
      end
      after_operate(source, params)
      redult
    end

    def get_arr(source, params)
      case source
      when 'layer'
        QuickNaming::LayerArr.tap{|arr| init_data(source, arr) if arr.empty?}
      when 'naming_setting'
        QuickNaming::SettingArr.tap{|arr| init_data(source, arr) if arr.empty?}
      when 'ns_category' then QuickNaming.get_setting_category_arr(params.parent_id)
      when 'ns_data' then QuickNaming.get_setting_data_arr(params.category_id)
      end
    end

    def get_new_obj(source, params)
      case source
      when 'layer' then QuickNaming.new_layer
      when 'ns_category' then QuickNaming.new_category
      when 'ns_data' then QuickNaming.new_data
      end
    end

    def import_data(source, arr)
      file_type = get_file_params_by_source(source)[0]
      file_path = get_import_file_path(file_type)
      import_data_from_file(arr, file_path) if file_path
    end

    def get_import_file_path(type)
      UI.openpanel("选择要导入的#{type}文件", '', "#{type.upcase} File|*.#{type};||")
    end

    def import_data_from_file(arr, file_path)
      arr.clear
      json = File.open(file_path, "r:UTF-8"){|f| f.read}
      arr.replace(JSON.parse(json))
    end

    def export_data_to_json(source, arr)
      file_params = get_file_params_by_source(source)
      save_path = get_export_file_path(*file_params)
      return if save_path.nil?
      File.open(save_path, "w"){|f| f.write(arr.to_json)}
    end

    def get_export_file_path(type, name)
      UI.savepanel("导出#{name}", nil, "#{name}_#{Time.now.strftime("%y%m%d%H%M%S")}.#{type}")
    end

    def confirm_init_data(source, arr)
      result = UI.messagebox('该操作将初始化数据, 您所作的修改会被清除, 是否继续?', MB_YESNO)
      init_data(source, arr) if result == IDYES
    end

    def init_data(source, arr)
      preset_data_path = ShinkQuickNaming.preset_data_path("#{source}.json")
      import_data_from_file(arr, preset_data_path) if File.exist?(preset_data_path)
    end

    def get_file_params_by_source(source)
      case source
      when 'layer' then ['json', '图层设置']
      when 'naming_setting' then ['json', '命名数据']
      end
    end

    def after_operate(source, params)
      case source
      when 'ns_category'
        QuickNaming::SettingArr.save if params.parent_id
      when 'ns_data'
        QuickNaming::SettingArr.save
      end
    end
  end

  UDOI = UnifiedDataOperationInterface
end
