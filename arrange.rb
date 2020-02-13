require 'fileutils'

def each_r(path, &block)
  Dir.foreach(path) do |name|
    next if name.start_with?('.')
    cpath = "#{path}/#{name.encode('UTF-8')}"
    if Dir.exist?(cpath)
      each_r(cpath, &block)
    else
      yield cpath
    end
  end
end

plugin_name = 'shink_quick_naming'
output_path = './dist'
from_path = '.'
pack_path = "#{output_path}/#{plugin_name}"
puts '清理打包环境'
FileUtils.mkdir(output_path) unless Dir.exist?(output_path)
FileUtils.rm_r(pack_path) if Dir.exist?(pack_path)
FileUtils.mkdir(pack_path)
puts '复制后端代码'
FileUtils.cp("#{from_path}/#{plugin_name}.rb", pack_path)
FileUtils.cp_r("#{from_path}/#{plugin_name}", pack_path)
puts '复制前端代码'
FileUtils.cp_r("#{from_path}/#{plugin_name}_front/dist", "#{pack_path}/#{plugin_name}")
each_r("#{pack_path}/#{plugin_name}/dist"){|path| FileUtils.remove_file(path) if path.end_with?('.map')}
puts '整理完毕'
