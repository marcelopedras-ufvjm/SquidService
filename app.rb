require 'sinatra/base'
require 'sinatra/reloader'
require 'logger'
#require_relative './boot'
#require_relative './api/api'

class App < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    set :squid_key => "1234"
  end


  before do
    authorized? "1234"
  end


  def authorized? squid_key
    unless squid_key == App.settings.squid_key
    content_type :json
    resp = {
        'authorized' => false,
        'error' => 'Invalid Squid key.'
    }

    halt(401,resp.to_json)
    end
  end

  run! if __FILE__ == $0
end

