require 'dm-core'
require 'dm-migrations'


#DataMapper.setup(:default, "sqlite3://#{File.dirname(__FILE__)}/development.db")
DataMapper.setup(:default, "sqlite3://#{File.dirname(__FILE__)}/development.db")
DataMapper::Logger.new($stdout, :debug)

require_relative './models/connection'

DataMapper.finalize
DataMapper.auto_migrate!