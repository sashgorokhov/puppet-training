# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "master"
  config.vm.network "public_network", ip: "192.168.50.50"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/kubernetes"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update -qq
    apt-get install -qqy puppet-module-puppetlabs-stdlib
    if ! `lsmod | grep -q br_netfilter`; then
      apt-get install -qqy linux-image-3.19.0-33-generic linux-image-extra-3.19.0-33-generic
      echo "br_netfilter" | tee -a /etc/modules
      echo "You need to reload machine."
      exit 1
    fi
  SHELL

  config.vm.provision "puppet"

end
