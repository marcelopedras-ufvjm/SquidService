#\ -w -o 192.168.1.20 -p 9898
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