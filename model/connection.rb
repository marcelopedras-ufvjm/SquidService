require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{File.expand_path('..',Dir.pwd)}/config/development.db")
class Connection
  property :id, Serial
  property :room_name, String, :required => true, :unique_index => :name
  property :connected, Boolean, :required => true, :default => true
  property :ip_range, String, :required => true
  property :connection_down_start, DateTime
  property :connection_down_end, DateTime

  property :updated_at, DateTime

  validates_presence_of :room_name
  validates_uniqueness_of :room_name, :ip_range
  validates_with_method :check_off_time

  def check_off_time
    status = true
    unless self.connected
      if self.connection_down_end && self.connection_down_start
        if self.connection_down_end < self.connection_down_start
          status = [false,'Connected é falso, logo o horário de religamento da internet deve ser maior que o horário de desligamento']
        end
      else
        status = [false, 'Connection down end ou Connection down start são nulos, porém Connected é falso']
      end
    end

    status
  end

  def self.list
    # id: 1,
    # room_name: 260,
    # connected: true,
    # ip_range: '192.168.11.0/24'
    # start_time: nil,
    # end_time: nil
    connections = Connection.all.map do |c|
      start_time_p = (c.connection_down_start ? c.connection_down_start.strftime("%d/%m/%y %H:%M:%S") : nil)
      end_time_p = (c.connection_down_end ? c.connection_down_end.strftime("%d/%m/%y %H:%M:%S") : nil)

      {
          id: c.id,
          room_name: c.room_name,
          connected: c.connected,
          ip_range: c.ip_range,
          down_time: start_time_p,
          up_time: end_time_p
      }



    end
    connections
  end
end