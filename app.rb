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
    # begin
    # squid_key =  params['params']['squid_key']
    # authorized? squid_key
    # rescue => e
    #   to_halt
    # end

  end


  def authorized? squid_key
    unless squid_key == App.settings.squid_key
      to_halt
    end
  end

  def to_halt
    content_type :json
    resp = {
        'authorized' => false,
        'error' => 'Invalid Squid key.'
    }

    halt(401,resp.to_json)
  end

  run! if __FILE__ == $0
end

