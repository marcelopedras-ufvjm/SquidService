require 'sinatra/base'
require 'logger'
require 'bundler'

Bundler.require

$: << '.'

Dir.glob('./{.}/*.rb').each {|file|
 #logger.info(file)
 require file
}

#require './app.rb'

# run Rack::URLMap.new({
#                          "/connection" => ConnectionController,
#                          "/login" => LoginController,
#                          "/" => ApplicationController
#                      })

run Api
