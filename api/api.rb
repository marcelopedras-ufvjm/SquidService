require_relative '../app'
require 'json'

class Api < App

  get '/test' do
    content_type :json

    t = `ls`
    formatted = t.split("\n")
    obj = {saida: formatted, nome: 'marcelo', sobrenome: 'pedras'}
    obj.to_json
  end

  get '/squid_sync' do
    content_type :json
    response = SquidSync.new('localhost',9696).sync
    #response = {a: 'squid data'}
    response
  end
end

