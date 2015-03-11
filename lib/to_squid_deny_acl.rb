require 'fileutils'
class ToSquidDenyAcl

  attr_accessor :root_path
  attr_reader :acl

  def initialize (root_path = "#{Dir.pwd}/squid_conf/labs/")
    @root_path = root_path
    @acl_folder = ''
    @acl = ''
    @internet_status = 'on'
  end

  def deny_network acl_name, ip_network
    @acl_folder = acl_name.downcase
    @internet_status = 'off'
    @acl = "acl #{acl_name} src #{ip_network}
     http_access deny #{acl_name.upcase}
     http_access deny #{acl_name.upcase} HTTPS"
  end

  def allow_network acl_name #only write blank file
    @acl_folder = acl_name.downcase
    @internet_status = 'on'
    @acl = ''
  end

  def write_acl
    FileUtils.mkdir_p "#{@root_path}#{@acl_folder}"
    File.open("#{@root_path}#{@acl_folder}/active_configuration.conf",'w') do |f|
      f.puts @acl
    end
    File.open("#{@root_path}#{@acl_folder}/internet_status.txt",'w') do |f|
      f.puts @internet_status
    end
  end
end