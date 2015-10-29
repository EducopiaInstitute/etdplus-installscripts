Install Scripts for ETDplus Application
===============================================

These scripts install the [ETDplus
application](https://github.com/VTUL/ETDplus) on a target server. They can be
used to install the application either to a VM under VirtualBox
via [Vagrant](https://www.vagrantup.com/) or to a server running under Amazon Web
Services (AWS).

When installing the ETDplus application, first, application settings are
configured to determine how it is to be installed on the server. Supplementary
files such as Web server certificates can also be placed in the `files/`
directory for deployment to the installed application. Next, the `bootstrap.sh`
script is used to set up the server and deploy the application on the chosen
platform: `vagrant` or `aws`.

Installation
------------

These scripts are intended to be run on a Unix-like system. They are tested to
work on Mac OSX.

To utilise the `vagrant` option, [Vagrant](https://www.vagrantup.com/) must
already been installed on the local system with
the [VirtualBox](http://www.virtualbox.org) provider working.

For the `aws` option to work, [awscli](https://aws.amazon.com/cli/) must be
installed and configured on the local system. (Under Mac OSX, this is most
easily done using [Homebrew](http://brew.sh/): `brew install awscli`.) In
particular, `awscli` must be configured correctly to access the AWS account
under which the new server will be installed and have the necessary EC2
permissions to create new servers, etc.

Finally, these install scripts must be installed on the local machine. This is
most easily done by cloning the
[VTUL/ETDplusInstall](https://github.com/VTUL/ETDplusInstall) repository from
GitHub:

```
git clone https://github.com/VTUL/ETDplusInstall.git
```

Configuration
-------------

Many aspects of how the application is installed can be configured by editing
the configuration files accompanying the install scripts. These are shell
scripts that contain variable definitions and are sourced in by the install
scripts during execution.

There is a general configuration file called `config.sh`. This file contains
common settings. These may then be overridden by platform-specific settings in
the `config_PLATFORM.sh` files, where `PLATFORM` currently is one of
either`vagrant` or `aws`. So, for example, settings in `config_vagrant.sh` will
override those in `config.sh` when installing via the `vagrant` option.

Some settings are only relevant for certain platforms and only make sense when
set in the corresponding `config_PLATFORM.sh` settings file. For example, it
isn't meaningful to set `AWS_AMI` in `config_vagrant.sh`, although it is
possible to do so.

Note that settings often refer to other settings. For example, `HYDRA_HEAD_DIR`
is usually set relative to `INSTALL_DIR`. If such a setting is overridden
(redefined) in a platform-specific configuration file then all the other
settings referring to it must also be re-specified in the platform-specific
configuration file, too (otherwise they will still refer to the original default
value).

Some important settings are as follows:

- `INSTALL_USER`: the user account under which the ETDplus application is
to be installed. This user must exist on the target server/VM and conventionally
is `vagrant` for the `vagrant` deployment option and `ubuntu` for the `aws`
option.
- `APP_ENV`: the Rails application environment in which the ETDplus
application will be installed and run. This is either `development`
or`production`.
- `SERVER_HOSTNAME`: the hostname of the Web server hosting the application.
- `AWS_KEY_PAIR`: the AWS SSH key pair used to access the deployed server. The
secret key of this SSH key *must* exist on the local system beforehand,
otherwise the user will not be able to SSH in to the deployed server.
- `AWS_EBS_SIZE`: the size of the EBS root volume in GB for the server being
created in AWS.

Note that many AWS-related settings refer to AWS entities such as AMIs; key
pairs; security groups; etc. These must all exist in the AWS account being used
to host the deployed server prior to running these install scripts.

The `aws` install tacitly expects the SERVER_HOSTNAME set in `config_aws.sh` to
resolve to the AWS_ELASTIC_IP set there, too.

### Secrets

The `files/` directory is used to convey server-specific data such as the Web
server certificate and key for HTTPS. Such files placed in `files/` will
override application defaults.

If a specific certificate is to be used then the certificate and key file should
be placed in `files/` and named `cert` and `key` respectively. If no such files
are present, the install scripts will generate a self-signed certificate and
place the resultant `cert` and `key` files under `files/`.

A `config/secrets.yml` will be generated if none is present in
`files/secrets.yml`.  This file will replace `$HYDRA_HEAD_DIR/config/secrets.yml`
during installation.

Usage
-----

To install the ETDplus application from scratch on a server using the
current local configuration file settings, do the following:

```
cd /path/to/install/scripts
./bootstrap.sh PLATFORM
```

Where `PLATFORM` is either `vagrant` or `aws`.  (Note, in the information below,
where `$VAR` appears, you should substitute it with the value of the `$VAR`
setting in the appropriate configuration file.  Do not use `$VAR` directly in
the example commands below.)

### vagrant

In the case of the `vagrant` option, a VM will be brought up and configured in
the current directory. The ETDplus application is accessible on the
local machine from a Web browser at `https://$SERVER_HOSTNAME:4443`.

You can use `vagrant ssh` to log in to this VM when it is up. When logged out of
the VM, `vagrant halt` can be used to shut down the VM. The command `vagrant
destroy` will destroy it entirely, requiring another `bootstrap.sh vagrant` to
recreate it.

Several ports in the running VM are made accessible on the local machine.
Accessing the local port in a Web browser will actually result in the forwarded
port being accessed on the VM. These ports are as follows:

Local | VM   | Description
----- | ---- | -----------
8983  | 8983 | Solr services
8888  | 8080 | Tomcat (Fedora 4)
8080  | 80   | ETDplus (HTTP)
4443  | 443  | ETDplus (HTTPS)

To access the Solr admin page in the VM from the local machine you would access
this URL: `http://localhost:8983/solr`

Similarly, to access the Fedora 4 REST endpoint in the VM from the local machine
you would access this URL: `http://localhost:8888/fedora/rest`

NB: Vagrant forwards these ports to the VM running on `localhost` from all
configured interfaces on the system.  This includes the configured WAN
interface. Unless otherwise firewalled to deny such traffic, the bootstrapped VM
will be available externally across the network.  E.g., if the WAN interface is
configured to respond as system.example.com, then users will be able to access
the ETDplus application running in the VM via the URL
`https://system.example.com:4443`.  External users will be able to access Solr
and Fedora 4 in the VM in similar fashion.

### aws

For the `aws` option, a server running the application will be provisioned in
AWS. After a while, it should be possible to log in to this machine via SSH:

```
ssh -i /path/to/$AWS_KEY_PAIR ubuntu@$SERVER_HOSTNAME
```

The installation and setup of the ETDplus application and associated
software could take quite a while. You may observe its progress when logged in
to the AWS server by looking at the file `/var/log/cloud-init-output.log`.

When installation is complete and services are running, you can access the
application via this URL: `https://$SERVER_HOSTNAME`
