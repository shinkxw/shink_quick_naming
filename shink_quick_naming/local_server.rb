module ShinkQuickNaming

  log_path = log_path('webrick.log')
  server = ApiServer.new(local_server_port, PATH, log_path)

  #插件版本
  server.add_api '/plugin_version' do |query|
    Version
  end

  #浏览器版本
  server.add_api '/ie_version' do |query|
    IsWindows ? IEVersion.to_s : '0'
  end

  #udoi统一接口
  server.add_api '/udoi' do |query|
    UDOI.operate_arr(query).to_json
  end

  Server = server

  LocalServer = ReuseService.new('local_server') do
    #开启本地服务器
    server_thread = Thread.new { Server.start(document_root_path) }
    sleep(0.1)
    #开启性能提升
    Circulator.new(0.1) {sleep(0.01)}.set_stop_condition{ !server_thread.alive? }
    server_thread
  end.at_close do |server_thread|
    server_thread.kill
  end
end
