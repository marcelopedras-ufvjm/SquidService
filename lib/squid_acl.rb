require 'fileutils'
class SquidAcl

  attr_accessor :root_path
  attr_reader :acl
  attr_accessor :squid_acls
  attr_accessor :file_path

  def initialize (root_path = "#{Dir.pwd}/squid_conf/labs/")
    @root_path = root_path
    @acl_folder = ''
    @acl = ''
    @internet_status = 'on'
    @file_path = ''
    @squid_acls = []
  end

  def deny_network(acl_name, ip_network)
    @acl_folder = acl_name.downcase
    @internet_status = 'off'
    @acl = "acl #{acl_name.upcase} src #{ip_network}
     http_access deny #{acl_name.upcase}
     http_access deny #{acl_name.upcase} HTTPS"
  end

  def allow_network(acl_name) #only write blank file
    @acl_folder = acl_name.downcase
    @internet_status = 'on'
    @acl = ''
  end

  def write_acl
    @file_path = "#{@root_path}#{@acl_folder}/active_configuration.conf"
    FileUtils.mkdir_p "#{@root_path}#{@acl_folder}"

    File.open("#{@root_path}#{@acl_folder}/active_configuration.conf",'w') do |f|
      f.puts @acl
    end

    File.open("#{@root_path}#{@acl_folder}/internet_status.txt",'w') do |f|
      f.puts @internet_status
    end

    @squid_acls.each { |a| a.write_acl }

  end

  def write_config
    File.open("#{@root_path}/active_configuration.conf",'w') do |f|
      f.puts "acl HTTPS port 443\n"
      f.puts "include #{@file_path}"
      @squid_acls.each do |a|
        f.puts "include #{a.file_path}"
      end
    end
  end
end