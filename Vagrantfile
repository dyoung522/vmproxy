# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty32'
  config.vm.box_check_update = false

  config.vm.network :private_network, ip: '192.168.50.100'
  config.vm.network :forwarded_port, guest: 3128, host: 3128 # Squid
  config.vm.network :forwarded_port, guest: 8080, host: 3128 # Squid

  # deletes standdard local port 2222 and adds 10022 to forward to port 22 on guest
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.network :forwarded_port, guest: 22, host: 10022, auto_correct: true

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Configure a small VirtualBox system (we don't need much)
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    v.customize ["modifyvm", :id, "--vram", "16"]
    v.name = 'vmproxy'
    v.memory = '512'
    v.cpus = 1
  end

  config.vm.provision 'System Configuration', type: 'shell', inline: <<-SHELL
    apt-get update
    apt-get -y install openconnect
    apt-get -y install nginx
  SHELL

  config.vm.provision 'Proxy Server', type: 'chef_solo' do |chef|
    chef.install = false
    chef.add_recipe "squid"
  end

  config.vm.provision 'copy do-not-cache', type: 'shell', run: 'always', inline: <<-SHELL
    [[ -f /vagrant/do-not-cache.txt ]] && cp /vagrant/do-not-cache.txt /etc/squid3/do-not-cache.txt
  SHELL

  config.vm.provision 'Create PAC', type: 'shell', run: 'always', path: 'scripts/build_proxy.rb'
  config.vm.provision 'Start VPN',  type: 'shell', run: 'always', path: 'scripts/start_vpn.sh'
end
