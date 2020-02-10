module ShinkQuickNaming
  module QuickNaming
    LayerArr = SuDb::ArrayDb.new_by_key('layer_arr')
    SettingArr = SuDb::ArrayDb.new_by_key('qns_arr')

    module_function

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
