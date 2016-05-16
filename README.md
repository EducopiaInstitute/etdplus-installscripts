Install Scripts for ETDplus Application
=======================================

These scripts install the [ETDplus application](https://github.com/EducopiaInstitute/etdplus) on a target server. They can be used to install the application either to a VM under VirtualBox or to a server running under Amazon Web Services (AWS). Installation is done via [Vagrant](https://www.vagrantup.com/).

When installing the ETDplus application, first, application settings are configured to determine how it is to be installed on the server. Supplementary files such as Web server certificates can also be placed in the `files/` directory for deployment to the installed application. Next, the `vagrant up` command is used to set up the server and deploy the application on the chosen platform: `vagrant` or `aws`. To deploy to AWS, select the `aws` Vagrant provider: `vagrant up --provider aws`. If no provider is specified, it defaults to VirtualBox, which will set up a local VM.

Installation
------------

These scripts are intended to be run on a Unix-like system. They are tested to work on Mac OSX.

To use these scripts, [Vagrant](https://www.vagrantup.com/) must already been installed on the local system with the [VirtualBox](http://www.virtualbox.org) provider working. For provisioning to AWS, the `aws` provider must also be installed. This can be done by executing the following command, which will install the `aws` Vagrant provider plugin: `vagrant plugin install vagrant-aws`.

Finally, these install scripts must be installed on the local machine. This is most easily done by cloning the[EducopiaInstitute/etdplus-installscripts](https://github.com/EducopiaInstitute/etdplus-installscripts) repository from GitHub:

```
git clone https://github.com/EducopiaInstitute/etdplus-installscripts
```

Configuration
-------------

Many aspects of how the application is installed can be configured by editing the configuration files accompanying the install scripts. These are shell scripts that contain variable definitions and are sourced in by the install scripts during execution.

There is a general configuration file called `config.sh`. This file contains common settings. These may then be overridden by platform-specific settings in the `config_PLATFORM.sh` files, where `PLATFORM` currently is one of either`vagrant` or `aws`. So, for example, settings in `config_vagrant.sh` will override those in `config.sh` when installing via the `vagrant` option.

Some settings are only relevant for certain platforms and only make sense when set in the corresponding `config_PLATFORM.sh` settings file. For example, it isn't meaningful to set `AWS_AMI` in `config_vagrant.sh`, although it is possible to do so.

Note that settings often refer to other settings. For example, `HYDRA_HEAD_DIR` is usually set relative to `INSTALL_DIR`. If such a setting is overridden (redefined) in a platform-specific configuration file then all the other settings referring to it must also be re-specified in the platform-specific configuration file, too (otherwise they will still refer to the original default value).

Some important settings are as follows:

-	`INSTALL_USER`: the user account under which the ETDplus application is to be installed. This user must exist on the target server/VM and conventionally is `vagrant` for the `vagrant` deployment option and `ubuntu` for the `aws` option.
-	`APP_ENV`: the Rails application environment in which the ETDplus application will be installed and run. This is either `development` or`production`.
-	`HYDRA_HEAD_GIT_REPO_URL`: the URL of the repository containing the ETDplus software. This URL should be one accessible via `git clone`.
-	`HYDRA_HEAD_GIT_REPO_DEPLOY_KEY`: If the `HYDRA_HEAD_GIT_REPO_URL` references a private repository then `HYDRA_HEAD_GIT_REPO_DEPLOY_KEY` can be used to designate an SSH deployment key used to clone the repository. If the repository is public, or otherwise doesn't require an SSH key to clone, then`HYDRA_HEAD_GIT_REPO_DEPLOY_KEY` should be set to an empty string, "".
-	`SERVER_HOSTNAME`: the hostname of the Web server hosting the application.
-	`AWS_KEY_PAIR`: the AWS SSH key pair used to access the deployed server. The secret key of this SSH key *must* exist on the local system beforehand, otherwise the user will not be able to SSH in to the deployed server.
-	`AWS_EBS_SIZE`: the size of the EBS root volume in GB for the server being created in AWS.

Note that many AWS-related settings refer to AWS entities such as AMIs; key pairs; security groups; etc. These must all exist in the AWS account being used to host the deployed server prior to running these install scripts.

The `aws` install tacitly expects the SERVER_HOSTNAME set in `config_aws.sh` to resolve to the AWS_ELASTIC_IP set there, too.

### Secrets

The `files/` directory is used to convey server-specific data such as the Web server certificate and key for HTTPS. Such files placed in `files/` will override application defaults.

If a specific Web site certificate is to be used then the certificate and key file should be placed in `files/` and named `cert` and `key` respectively. If no such files are present, the install scripts will generate a self-signed certificate and place the resultant `cert` and `key` files under `files/`.

A `config/secrets.yml` will be generated if none is present in`files/secrets.yml`. This file will replace `$HYDRA_HEAD_DIR/config/secrets.yml` during installation.

### Deployment keys

If the ETDplus code is in a Git repository that requires an SSH key to be able to clone it then this private key file can be placed in the `files/` directory. The *filename* of this SSH private key file is then defined in the`HYDRA_HEAD_GIT_REPO_DEPLOY_KEY` setting. (Do not specify the full pathname, only the filename under `files/`.)

Private Git repositories are supported via the SSH transport. A deployment key is supported, as mentioned above. In addition, on the `vagrant` platform, SSH Agent forwarding is enabled to the VM that is created. In this case, any SSH keys available in the local SSH Agent are also available in the VM. Any Git repository that can be cloned via an SSH Agent key on the host system can thus also be cloned in the bootstrapped VM. This can avoid the use of an explicit deployment key if the SSH Agent holds all the needed keys when using`bootstrap.sh` on the `vagrant` platform.

Usage
-----

To install the ETDplus application from scratch on a server using the current local configuration file settings, do the following:

```
cd /path/to/install/scripts
vagrant up
```

This will install to a local VM. To install to AWS do the following:

```
cd /path/to/install/scripts
vagrant up --provider aws
```

IMPORTANT: Make sure that `AWS_KEYPAIR_PATH` is defined either in your current environment or in the `config_aws.sh` configuration file to point to the directory in which your `AWS_KEY_PAIR` resides. This is necessary to locate the AWS private key used to access the server being provisioned so that Vagrant can log in to it after creation and set up the ETDplus application using the installation scripts. Failure to define `AWS_KEYPAIR_PATH` (or `AWS_KEY_PAIR`) will cause `vagrant up --provider aws` to fail.

(Note, in the information below, where `$VAR` appears, you should substitute it with the value of the `$VAR` setting in the appropriate configuration file. Do not use `$VAR` directly in the example commands below.)

### Local VM

In the case of the `vagrant up` option, a VM will be brought up and configured in the current directory. The ETDplus application is accessible on the local machine from a Web browser at `https://$SERVER_HOSTNAME:4443`.

You can use `vagrant ssh` to log in to this VM when it is up. When logged out of the VM, `vagrant halt` can be used to shut down the VM. The command `vagrant destroy` will destroy it entirely, requiring another `vagrant up` to recreate it.

Several ports in the running VM are made accessible on the local machine. Accessing the local port in a Web browser will actually result in the forwarded port being accessed on the VM. These ports are as follows:

| Local | VM   | Description       |
|-------|------|-------------------|
| 8983  | 8983 | Solr services     |
| 8888  | 8080 | Tomcat (Fedora 4) |
| 8080  | 80   | ETDplus (HTTP)    |
| 4443  | 443  | ETDplus (HTTPS)   |

To access the Solr admin page in the VM from the local machine you would access this URL: `http://localhost:8983/solr`

Similarly, to access the Fedora 4 REST endpoint in the VM from the local machine you would access this URL: `http://localhost:8888/fedora/rest`

NB: Vagrant forwards these ports to the VM running on `localhost` from all configured interfaces on the system. This includes the configured WAN interface. Unless otherwise firewalled to deny such traffic, the bootstrapped VM will be available externally across the network. E.g., if the WAN interface is configured to respond as system.example.com, then users will be able to access the ETDplus application running in the VM via the URL`https://system.example.com:4443`. External users will be able to access Solr and Fedora 4 in the VM in similar fashion.

### AWS

For the `vagrant up --provider aws` option, a server running the application will be provisioned in AWS. After a while, it should be possible to log in to this machine via SSH:

```
ssh -i /path/to/$AWS_KEY_PAIR ubuntu@$SERVER_HOSTNAME
```

Or, more simply, from the scripts directory you can issue the following command:

```
vagrant ssh
```

The installation and setup of the ETDplus application and associated software could take quite a while. Its progress will be logged to the screen during the execution of `vagrant up --provider aws`.

When installation is complete and services are running, you can access the application via this URL: `https://$SERVER_HOSTNAME`
