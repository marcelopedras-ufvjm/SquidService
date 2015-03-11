require_relative '../app'
require 'to_squid_deny_acl'
require 'json'

class Api < App

  get '/test' do
    content_type :json

    t = `ls`
    formatted = t.split("\n")
    obj = {saida: formatted, nome: 'marcelo', sobrenome: 'pedras'}
    obj.to_json
  end

  get '/squid_sync' do
    content_type :json
    response = SquidSync.new('localhost',9696).sync
    #response = {a: 'squid data'}
    response
  end

  get '/novo_test' do
    content_type :json

    {a: 1, b:2}.to_json

  end

  get '/manage/internet/:lab/:status' do
    content_type :json
    a_labs  = %w"lab1 lab2 lab3 lab4 lab5"
    a_status = %w"on off"
    a_network_ips = {
        lab1: '192.168.11.0/24',
        lab2: '192.168.12.0/24',
        lab3: '192.168.13.0/24',
        lab4: '192.168.14.0/24',
        lab5: '192.168.15.0/24'
    }

    lab = params['lab']
    status = params['status']

    unless a_labs.include?(lab) && a_status.include?(status)
      return {error: 'parametros invalidos'}.to_json
    end


    acl = ToSquidDenyAcl.new
    if status == 'on'
      acl.allow_network(lab)
    else
      acl.deny_network(lab,a_network_ips[lab.to_sym])
    end

    acl.write_acl

    {success: true}.to_json

  end
end

