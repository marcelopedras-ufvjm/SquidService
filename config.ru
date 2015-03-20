#\ -w -o localhost -p 9898
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

run Api