require 'rest_client'
class SquidSync
  def initialize(ip, port)
    @ip = ip
    @port = port
    @host = "#{@ip}:#{@port}"
  end
  def sync
    #response = {a: 'squid data'}
    response = RestClient.post("#{@host}/connection/squid_sync", data: {lab1: "Esses são alguns dados", squid_key: Sinatra::Application.settings.squid_key})
  end
end