# Vagrantfile to install ETDplus application under VirtualBox or AWS

# To install under AWS you need to have the vagrant-aws provider plugin installed.
# You can install this using the following command:
#
#   vagrant plugin install vagrant-aws
#

def read_config( platform )
  env = %x{./printvars.sh "#{platform}"}
  env.split("\n").each do |line|
    key, value = line.split("=", 2)
    ENV[key] ||= value unless value.nil? or value.empty? or key == "SHELLOPTS"
  end
end

Vagrant.configure(2) do |config|
  # Enable SSH agent forwarding to make deployment easier for developers
  config.ssh.forward_agent = true
  # Providers
  config.vm.provider :virtualbox do |vb, override|
    read_config( :vagrant )
    override.vm.box = "ubuntu/trusty64"
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
    # Forward Solr port in VM to local machine
    override.vm.network :forwarded_port, host: 8983, guest: 8983
    # Forward Tomcat/Fedora port in VM to port 8888 on local machine
    override.vm.network :forwarded_port, host: 8888, guest: 8080
    # Forward HTTP port in VM to port 8080 on local machine
    override.vm.network :forwarded_port, host: 8080, guest: 80
    # Forward HTTPS port in VM to port 4443 on local machine
    override.vm.network :forwarded_port, host: 4443, guest: 443
    override.vm.provision :shell, args: ["vagrant", "/vagrant"], privileged: true,
      path: 'bootstrap_server.sh'
  end

  config.vm.provider :aws do |aws, override|
    read_config( :aws )
    override.vm.box = "aws_dummy"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.keypair_name = ENV['AWS_KEY_PAIR']
    aws.ami = ENV['AWS_AMI'] # Ubuntu Trusty LTS
    aws.region = ENV['AWS_REGION']
    aws.instance_type = ENV['AWS_INSTANCE_TYPE']
    aws.security_groups = ENV['AWS_SECURITY_GROUP_IDS'].tr("''", "").split
    aws.elastic_ip = ENV['AWS_ELASTIC_IP']
    aws.subnet_id = ENV['AWS_SUBNET_ID']
    aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => ENV['AWS_EBS_SIZE'] }]
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "#{ENV['AWS_KEYPAIR_PATH'].tr("''", "")}/#{ENV['AWS_KEY_PAIR']}"
    aws.tags = {
      'Name' => "ETDplus"
    }
    override.vm.provision :shell, args: ["aws", "/vagrant"], privileged: true,
      path: 'bootstrap_server.sh'
  end
end
