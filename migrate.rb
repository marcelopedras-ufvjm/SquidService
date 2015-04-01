require 'dm-core'
require 'dm-migrations'

if ENV['APP_ENVIRONMENT'] == 'production'
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")
elsif ENV['APP_ENVIRONMENT'] == 'test'
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
else
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

DataMapper::Logger.new($stdout, :debug)

require_relative './models/connection'

DataMapper.finalize
DataMapper.auto_migrate!