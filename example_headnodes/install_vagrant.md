download correct vagrant package at: https://www.vagrantup.com/downloads (seperate per distro) OR install through your package manager (sudo apt-get update, sudo apt-get install vagrant)

download box: https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box

run command to install vagrant plugins: vagrant plugin install vagrant-hostmanager vagrant-mutate vagrant-libvirt

mutate the box you downloaded for libvirt: vagrant mutate ubuntu-14.04-amd64-vbox.box libvirt

add the box: vagrant box add base_box ubuntu-14.04-amd64-vbox.box

boot the vagrant vm: vagrant up --provider libvirt
