require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'date'
require_relative '../lib/squid_acl'
require 'rest-client'
require 'json'

#DataMapper.setup(:default, "sqlite3://#{File.expand_path(File.join(File.dirname(__FILE__), "..","development.db"))}")
#DataMapper::Logger.new($stdout, :debug)
#DataMapper::Model.raise_on_save_failure = true

class Connection

  include DataMapper::Resource
  property :id, Serial
  property :room_name, String, :required => true, :unique_index => :name
  property :connected, Boolean, :required => true, :default => true
  property :ip_range, String, :required => true
  property :down_time, DateTime
  property :up_time, DateTime

  property :updated_at, DateTime

  validates_presence_of :room_name
  validates_uniqueness_of :room_name, :ip_range
  validates_with_method :check_off_time

  def check_off_time
    status = true
    unless self.connected
      if self.up_time && self.down_time
        if self.up_time < self.down_time
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
      start_time_p = (c.down_time ? c.down_time.strftime("%d/%m/%y %H:%M:%S") : nil)
      end_time_p = (c.up_time ? c.up_time.strftime("%d/%m/%y %H:%M:%S") : nil)

      {
          id: c.id,
          room_name: c.room_name,
          connected: c.connected,
          ip_range: c.ip_range,
          down_time: start_time_p,
          up_time: end_time_p,
          updated_at: c.updated_at
      }
    end
    connections
  end

  def self.sync(connections_hashs)
    #TODO - tratar exceções
    result = connections_hashs.map do |c|
      connection = Connection.first({:room_name => c['room_name']})
      unless connection
        connection = Connection.new
        connection.room_name =  c['room_name']
      end

      connection.connected   = c['connected']

      if connection.connected
        connection.down_time = nil
        connection.up_time   = nil
      else
        connection.down_time = DateTime.strptime(c['down_time'], "%d/%m/%Y %H:%M:%S")
        connection.up_time   = DateTime.strptime(c['up_time'], "%d/%m/%Y %H:%M:%S")
      end

      connection.ip_range    = c['ip_range']
      connection.save
      connection
    end
    to_delete = Connection.all - result
    to_delete.destroy
    result
  end

  def self.get_down_connections
    Connection.all(connected: false)
  end

  def self.get_up_connections
    Connection.all(connected: true)
  end

  def self.to_squid_conf

    connections_down = get_down_connections

    connections_up = get_up_connections

    acls_down = connections_down.map do |c|
      acl = SquidAcl.new
      acl.deny_network(c.room_name, c.ip_range)
      acl
    end

    acls_up = connections_up.map do |c|
      acl = SquidAcl.new
      acl.allow_network(c.room_name)
      acl
    end

    acls = acls_down + acls_up

    first_acl = acls.shift
    if first_acl
      while acls.count > 0
        first_acl.squid_acls.push(acls.shift)
      end
    end

    first_acl.write_acl
    first_acl.write_config

  end

  def self.to_whenever_conf
    path = File.expand_path(File.join(File.dirname(__FILE__), "..","config"))

    down_connections = get_down_connections
    buffer = []

    down_connections.each do |c|
      up_time = c.up_time.strftime("%H:%M%P")
      string_task = "every 1.day, :at => '#{up_time}' do runner \"Connection.up_connection_on_time_out\" end"
      buffer.push(string_task)
    end


    File.open("#{path}/schedule.rb",'w') do |f|
      f.puts "require 'whenever'"
      f.puts "require 'active_support/core_ext/numeric/time'"
      f.puts "require_relative '../models/connection'"
      f.puts "set :output, \"#{path}/cron_log.log\""

      buffer.each do |b|
        f.puts b
      end
    end
    `whenever -f "#{path}/schedule.rb" --update-crontab`
  end

  def on
    self.down_time  = nil
    self.up_time    = nil
    self.connected  = true
    save
  end

  def off(down_time,end_time)
    self.down_time  = down_time
    self.up_time    = end_time
    self.connected  = false
    save
  end

  def self.up_connection_on_time_out
    now = DateTime.now
    Connection.get_down_connections.each do |c|
      if c.up_time <= now
        c.on
      end
    end

    Connection.to_whenever_conf
    Connection.to_squid_conf
    #TODO - Adicionar chamada de to_squid_conf para reescrever as configurações do squid, e também chamar squid3 -k reconfigure para recarregar as regras do squid
    `sudo squid -k reconfigure`
    Connection.notify
  end

  def self.notify
    data = Connection.list.to_json
    #TODO - Mudar squid_key para enviroment e usar algum esquema de criptografia
    squid_key = ENV['SQUID_KEY']
    RestClient.post("#{ENV['INTERNET_MANAGER_HOST']}:9696/connection/squid_sync", {:data => data, :squid_key=> squid_key})
  end
end
