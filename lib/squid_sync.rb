require 'rest_client'
class SquidSync
  def initialize(ip, port)
    @ip = ip
    @port = port
    @host = "#{@ip}:#{@port}"
  end
  def sync
    #response = {a: 'squid data'}
    p = {lab1: "Esses sao alguns dados", squid_key: App.settings.squid_key}
    RestClient.post("#{@host}/connection/squid_sync", data: p)
  end
end