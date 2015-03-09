require 'rest_client'
class SquidSync
  def self.sync
    #response = {a: 'squid data'}
    response = RestClient.get('localhost:9494/connection/squid_sync', data: {lab1: "Esses são alguns dados"})
  end
end