
require_relative './models/connection'
DataMapper::Model.raise_on_save_failure = true


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