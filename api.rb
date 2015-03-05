require "app"
require 'json'

class Api < App

  get '/test' do
    content_type :json

    t = `ls`
    formatted = t.split("\n")
    obj = {saida: formatted, nome: 'marcelo', sobrenome: 'pedras'}
    obj.to_json
  end
end