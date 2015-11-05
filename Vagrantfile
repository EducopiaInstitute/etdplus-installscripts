# Vagrantfile to install Data Repository application under VirtualBox

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provider 'virtualbox' do |vb|
    vb.cpus = 2
    vb.memory = 3072
  end
  # Enable SSH agent forwarding to make deployment easier for developers
  config.ssh.forward_agent = true
  # Forward Solr port in VM to local machine
  config.vm.network :forwarded_port, host: 8983, guest: 8983
  # Forward Tomcat/Fedora port in VM to port 8888 on local machine
  config.vm.network :forwarded_port, host: 8888, guest: 8080
  # Forward HTTP port in VM to port 8080 on local machine
  config.vm.network :forwarded_port, host: 8080, guest: 80
  # Forward HTTPS port in VM to port 4443 on local machine
  config.vm.network :forwarded_port, host: 4443, guest: 443
  config.vm.provision :shell, args: ["vagrant", "/vagrant"], privileged: true,
    path: 'bootstrap_server.sh'
end
