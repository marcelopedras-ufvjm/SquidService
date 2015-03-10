#\ -w -o localhost -p 9898
require 'bundler'
require 'rack'


Bundler.require

$: << '.'
$: << './lib/'
$: << './api/'

#require_relative './app'

Dir.glob('./{lib,api}/*.rb').each {|file|
  puts(file)
  require file
}

run Api