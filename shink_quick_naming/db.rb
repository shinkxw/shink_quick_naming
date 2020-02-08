module ShinkQuickNaming
  SuDb.set_section("#{PluginName}_DB")
  Config = SuDb::Config.new_by_key('config')
end
