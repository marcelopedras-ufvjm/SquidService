#\ -w -o 0.0.0.0 -p 9898

require 'bundler'
require 'rack'


Bundler.require

$: << '.'
$: << './lib/'
$: << './api/'
$: << './models/'

#require_relative './app'

Dir.glob('./{lib,api,models}/*.rb').each {|file|
  puts(file)
  require file
}

ENV["RACK_ENV"]='production'

run Api
