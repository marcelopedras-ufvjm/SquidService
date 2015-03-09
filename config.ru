#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra/base'
require 'logger'
require 'bundler'


Bundler.require

$: << '.'
$: << './lib/'
$: << './api/'

Dir.glob('./{.,lib,api}/*.rb').each {|file|
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
