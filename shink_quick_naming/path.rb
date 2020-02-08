module ShinkQuickNaming
  PATH = File.dirname(__FILE__)
  module_function

  def data_path
    "#{DocumentsPath}/sketchup_plugin/#{PluginName}_#{SuVersion}"
  end

  def log_path(name = '')
    "#{data_path}/log/#{name}"
  end

  def tmp_path(name = '')
    "#{data_path}/tmp/#{name}"
  end

  def small_icon_path(icon_name)
    "#{PATH}/icon/#{icon_name}_32.png"
  end

  def large_icon_path(icon_name)
    "#{PATH}/icon/#{icon_name}_64.png"
  end

  def preset_data_path(file_name)
    "#{PATH}/preset_data/#{file_name}"
  end

  def local_page_path(type)
    "#{local_server_path}/index.html?type=#{type}&time=#{Time.now.to_i}"
  end

  def local_server_path
    "http://localhost:#{local_server_port}"
  end

  def local_server_port
    '38586'
  end

  def document_root_path
    if IsDevelop
      "#{PATH}/../shink_quick_naming_front/dist"
    else
      "#{PATH}/dist"
    end
  end

  FileUtils.mkdir_p(log_path)
  FileUtils.remove_dir(tmp_path) if Dir.exist?(tmp_path)
  FileUtils.mkdir_p(tmp_path)
end
