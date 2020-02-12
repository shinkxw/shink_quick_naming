module ShinkQuickNaming
  module QuickNaming
    LayerArr = SuDb::ArrayDb.new_by_key('layer_arr')
    SettingArr = SuDb::ArrayDb.new_by_key('qns_arr')

    module_function

    def current_entity_info
      selection = Sketchup.active_model.selection
      case selection.length
      when 0 then return nil
      when 1
        centity = selection.first
        if centity.is_a?(Sketchup::ComponentInstance) || centity.is_a?(Sketchup::Group)
          data = build_entity_info(centity)
        else
          return nil
        end
      else
        return nil
      end
      data.to_json
    end

    def build_entity_info(entity)
      definition = entity.definition
      {}.tap do |data|
        data[:name] = definition.name
        layer = entity.layer
        data[:layer_name] = layer ? layer.name : nil
      end
    end

    def set_current_entity_name_and_layer(name, layer_id)
      centity = Sketchup.active_model.selection.first
      if centity && centity.is_a?(Sketchup::ComponentInstance) || centity.is_a?(Sketchup::Group)
        centity.name = name if centity.name != name#修改实例名称
        centity.definition.name = name if centity.definition.name != name#修改定义名称
        if layer_id
          layer_name = get_layer_name_by_id(layer_id)
          return if layer_name.nil?
          layer_initialization#图层初始化
          layer = Sketchup.active_model.layers.add(layer_name)
          centity.layer = layer
        end
      end
    end

    def get_layer_name_by_id(layer_id)
      return 'Layer0' if layer_id == 'Layer0'
      layer = UDOI.get_arr('layer', {}).find{|l| l['id'] == layer_id}
      layer ? layer['name'] : nil
    end

    def layer_initialization
      model = Sketchup.active_model
      has_init = model.get_attribute(PluginName, 'layer_has_init', false)
      unless has_init
        layers = model.layers
        UDOI.get_arr('layer', {}).each{|layer| layers.add(layer['name'])}
        model.set_attribute(PluginName, 'layer_has_init', true)
      end
    end

    #图层设置----------------------------
    def new_layer
      {'id' => UID.generate, 'name' => ''}
    end

    #命名设置-------------------------------------
    #分类节点 id, name, c_arr, d_arr
    def get_setting_category_arr(parent_id)
      return SettingArr if parent_id.nil?
      category = find_category(parent_id)
      category ? category['c_arr'] : nil
    end

    def get_setting_data_arr(category_id)
      category = find_category(category_id)
      category ? category['d_arr'] : nil
    end

    def find_category(id)#遍历查找指定id的分类
      current_arr = SettingArr
      while current_arr.length > 0
        next_arr = []
        current_arr.each do |category|
          return category if category['id'] == id
          category['c_arr'].each{|c| next_arr << c}
        end
        current_arr = next_arr
      end
    end

    def new_category
      {'id' => UID.generate, 'name' => '', 'c_arr' => [], 'd_arr' => []}
    end

    def new_data
      {'id' => UID.generate, 'name' => '', 'layer_id' => ''}
    end
  end
end
