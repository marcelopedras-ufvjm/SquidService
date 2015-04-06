require 'dm-core'
require 'dm-migrations'


env = ARGV[0]
path =  "sqlite3://#{Dir.pwd}"

puts path

if env == 'production'
  DataMapper.setup(:default, "#{path}/production.db")
elsif env == 'test'
  DataMapper.setup(:default, "#{path}/test.db")
else
  DataMapper.setup(:default, "#{path}/development.db")
end

DataMapper::Logger.new($stdout, :debug)

require_relative './models/connection'

DataMapper.finalize
DataMapper.auto_migrate!