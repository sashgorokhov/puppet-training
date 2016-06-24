# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "master"
  config.vm.network "public_network", ip: "192.168.50.50"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/kubernetes"

  config.vm.provision "shell", inline: <<-SHELL
    set -ex

    if [ ! -f ~/puppetlabs-release-trusty.deb ]; then
        cd ~ && wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
        sudo dpkg -i puppetlabs-release-trusty.deb
    fi

    apt-get update -qq
    apt-get install -y puppet-common
    puppet module install puppetlabs-stdlib gini-archive
    if ! `lsmod | grep -q br_netfilter`; then
      echo "br_netfilter kernel module not found, upgrading kernel"
      apt-get install -y linux-image-3.19.0-33-generic linux-image-extra-3.19.0-33-generic
      echo "br_netfilter" | tee -a /etc/modules
      echo "You need to reload machine."
      exit 1
    else
      apt-get autoremove -qq
    fi
  SHELL

  config.vm.provision "puppet"

end
