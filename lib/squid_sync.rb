require 'rest_client'
require_relative 'squid_acl'
class SquidSync
  # def initialize(ip, port)
  #   @ip = ip
  #   @port = port
  #   @host = "#{@ip}:#{@port}"
  # end
  # def sync
  #   #response = {a: 'squid data'}
  #   p = {lab1: "Esses sao alguns dados", squid_key: App.settings.squid_key}
  #   RestClient.post("#{@host}/connection/squid_sync", data: p)
  # end

  def self.subscribe_file(labs)
    begin
      acls = labs.map do |lab|
        acl = SquidAcl.new
        if lab['internet']
          acl.allow_network(lab['lab'])
        else
          acl.deny_network(lab['lab'], lab['ip_range'])
        end
        acl
      end

      first_acl = acls.shift
      if first_acl
        while acls.count > 0
          first_acl.squid_acls.push(acls.shift)
        end
      end

      first_acl.write_acl
      first_acl.write_config
      return true
    rescue => err
      print err.backtrace.join("\n")
      return false
    end
  end
end