1) download correct vagrant package at: 

    https://www.vagrantup.com/downloads (seperate package per distro) 

OR install through your package manager (sudo yum update, sudo yum install vagrant)

2) download box: 

    wget https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box

3) run command to install vagrant plugins:

    vagrant plugin install vagrant-hostmanager vagrant-mutate vagrant-libvirt

4) mutate the box you downloaded for libvirt: 

    vagrant mutate ubuntu-14.04-amd64-vbox.box libvirt

5) add the box: 

    vagrant box add base_box ubuntu-14.04-amd64-vbox.box

6) boot the vagrant vm: 

    vagrant up --provider libvirt
