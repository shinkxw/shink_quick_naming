require "sketchup.rb"
require "extensions.rb"

module ShinkQuickNaming
  PluginName = 'shink_quick_naming'
  PluginChineseName = '快速命名分层'
  Version = '0.0.1'.freeze

  load_path = File.join(File.dirname(__FILE__), "#{PluginName}/load.rb")
  extension = SketchupExtension.new(PluginChineseName, load_path)
  extension.version = Version
  extension.creator = 'Shink'
  Sketchup.register_extension(extension, true)
end
