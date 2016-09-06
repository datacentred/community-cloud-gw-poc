# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.define "pubcloud" do |pub|
    pub.vm.box = "ubuntu/trusty64"
    pub.ssh.forward_agent = true
    # eth1, this will be the endpoint
    pub.vm.network :private_network, ip: "192.168.27.100"
    # eth2, this will be the OpenStack "public" network
    # ip and subnet mask should match floating_ip_range var in devstack.yml
    pub.vm.network :private_network, ip: "172.24.4.225", :netmask => "255.255.255.0", 
      :auto_config => false, virtualbox__intnet: "pubcloud"
    pub.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 6192]
        vb.customize ["modifyvm", :id, "--cpus", 4]
       	# eth2 must be in promiscuous mode for floating IPs to be accessible
       	vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
    pub.vm.provision :ansible do |ansible|
        ansible.host_key_checking = false
        ansible.playbook = "devstack.pub.yml"
        ansible.verbose = "v"
    end
    pub.vm.provision :shell, :inline => "cd devstack; sudo -u vagrant env HOME=/home/vagrant ./stack.sh"
    pub.vm.provision :shell, :inline => "ovs-vsctl add-port br-ex eth2"
    pub.vm.provision :shell, :inline => "virsh net-destroy default"
  end

  config.vm.define "comcloud" do |com|
    com.vm.box = "ubuntu/trusty64"
    com.ssh.forward_agent = true
    # eth1, this will be the endpoint
    com.vm.network :private_network, ip: "192.168.29.100"
    # eth2, this will be the OpenStack "comlic" network
    # ip and subnet mask should match floating_ip_range var in devstack.yml
    com.vm.network :private_network, ip: "172.24.6.225", :netmask => "255.255.255.0", 
      :auto_config => false, virtualbox__intnet: "comcloud"
    com.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 6192]
        vb.customize ["modifyvm", :id, "--cpus", 4]
       	# eth2 must be in promiscuous mode for floating IPs to be accessible
       	vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
    com.vm.provision :ansible do |ansible|
        ansible.host_key_checking = false
        ansible.playbook = "devstack.com.yml"
        ansible.verbose = "v"
    end
    com.vm.provision :shell, :inline => "sed -i 's/172.24.4.0/172.24.6.0/g' /home/vagrant/devstack/stackrc"
    com.vm.provision :shell, :inline => "sed -i 's/172.24.4/172.24.6/g' /home/vagrant/devstack/lib/neutron-legacy"
    com.vm.provision :shell, :inline => "sed -i 's/172.24.4/172.24.6/g' /home/vagrant/devstack/tools/xen/xenrc"
    com.vm.provision :shell, :inline => "cd devstack; sudo -u vagrant env HOME=/home/vagrant ./stack.sh"
    com.vm.provision :shell, :inline => "ovs-vsctl add-port br-ex eth2"
    com.vm.provision :shell, :inline => "virsh net-destroy default"
  end

  config.vm.define "gateway" do |gw|
    gw.vm.box = "bento/ubuntu-16.04"
    gw.ssh.forward_agent = true
    gw.vm.provision "shell", path: "scripts/gateway.sh"
    gw.vm.synced_folder ".", "/test"
    gw.vm.network :private_network, ip: "172.24.4.5", :netmask => "255.255.255.0",
       virtualbox__intnet: "pubcloud"
    gw.vm.network :private_network, ip: "172.24.6.5", :netmask => "255.255.255.0",
       virtualbox__intnet: "comcloud"
    gw.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 512]
        vb.customize ["modifyvm", :id, "--cpus", 1]
    end
  end

end
