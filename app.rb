require 'sinatra/base'
require 'sinatra/reloader'
require 'logger'
#require_relative './boot'
#require_relative './api/api'

class App < Sinatra::Base

  configure :production do
    #production configuration here
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")

  end

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    register Sinatra::Reloader
    #set :squid_key => "1234"
    #ENV['SQUID_HOST'] = "192.168.70.33"
    #ENV['INTERNET_MANAGER_HOST'] = "192.168.70.34"
    #ENV['LDAP_HOST'] = "192.168.70.35"
    #ENV['APP_ENVIRONMENT'] = "devlopment"
    #ENV['AUTOMATIC_PW']="123456"
    #ENV['ATTR_ENCRYPTED_PW']="123456"
  end

  configure :test do
    #test configuration here
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
  end

  before do
    begin
    squid_key =  params['params']['squid_key']
    authorized? squid_key
    rescue => e
      to_halt
    end
  end


  def authorized? squid_key
    unless squid_key == ENV['SQUID_KEY'] #App.settings.squid_key
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

