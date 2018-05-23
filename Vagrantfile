# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  # config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/xenial64"
  # config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider "virtualbox" do |v|
    v.name = "tinytoos"
    v.memory = 256
  end

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)"
end
