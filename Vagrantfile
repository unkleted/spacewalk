Vagrant.configure("2") do |config|
  config.vm.define "server" do |server|
    server.vm.box = "centos/7"
    server.vm.provider "virtualbox" do |v|
      v.memory = "4096"
    end
    server.vm.network "private_network", ip: "192.168.56.11"
    server.vm.network "forwarded_port", guest: 443, host: 443
    server.vm.provision "file", source: "tmp/", destination: "/tmp"
    server.vm.provision "shell", path: "server_setup.sh"
  end
  config.vm.define "client" do |client|
    client.vm.box = "centos/7"
    client.vm.hostname = "cl7.jhd.local"
    client.vm.network "private_network", ip: "192.168.56.22"
    client.vm.provision "shell", path: "client_setup.sh"
  end
  config.vm.define "client2" do |client2|
    client2.vm.box = "centos/6"
    client2.vm.hostname = "cl6.jhd.local"
    client2.vm.network "private_network", ip: "192.168.56.23"
    client2.vm.provision "shell", path: "client_setup.sh"
  end
end