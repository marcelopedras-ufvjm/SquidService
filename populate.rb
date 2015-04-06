
require_relative './models/connection'
DataMapper::Model.raise_on_save_failure = true


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

# id: 1,
# room_name: 260,
# connected: true,
# ip_range: '192.168.11.0/24'
# start_time: nil,
# end_time: nil

c1 = Connection.new
c1.room_name = 'lab1'
c1.connected = true
c1.ip_range = '192.168.11.0/24'
c1.save

c2 = Connection.new
c2.room_name = 'lab2'
c2.connected = true
c2.ip_range = '192.168.12.0/24'
c2.save

c3 = Connection.new
c3.room_name = 'lab3'
c3.connected = true
c3.ip_range = '192.168.13.0/24'
c3.save

c4 = Connection.new
c4.room_name = 'lab4'
c4.connected = true
c4.ip_range = '192.168.14.0/24'
c4.save

c5 = Connection.new
c5.room_name = 'lab5'
c5.connected = true
c5.ip_range = '192.168.15.0/24'
c5.save