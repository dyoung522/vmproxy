# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.network :private_network, ip: '192.168.50.100'
  config.vm.network :forwarded_port, guest: 3128, host: 3128 # Squid

  # Configure a small VirtualBox system (we don't need much)
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    v.name = 'vmproxy'
    v.memory = '512'
    v.cpus = 1
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define 'atlas' do |push|
  #   push.app = 'YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME'
  # end

  config.vm.provision 'System Configuration', type: 'shell', inline: <<-SHELL
    apt-get update
    apt-get -y upgrade
    apt-get -y autoremove
    apt-get -y install openconnect
    apt-get -y install nginx
  SHELL

  config.vm.provision 'Proxy Server', type: 'chef_solo' do |chef|
    chef.add_recipe "squid"
  end

  config.vm.provision 'Create PAC', type: 'shell', run: 'always', path: 'scripts/build_proxy.rb'
  config.vm.provision 'Start VPN',  type: 'shell', run: 'always', path: 'scripts/start_vpn.sh'
end
