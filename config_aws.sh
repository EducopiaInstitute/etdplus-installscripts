#!/bin/sh
# Defaults for AWS environment Installs
# The git repository to pull changes from during setup.
HYDRA_HEAD_GIT_REPO_URL="git@github.com:EducopiaInstitute/etdplus.git"
# SSH deployment key, if any, needed for cloning above repository
HYDRA_HEAD_GIT_REPO_DEPLOY_KEY="etdplus_deploykey"
# The branch of the repository to pull.
HYDRA_HEAD_GIT_BRANCH="master"
# Name of user to install under (must already exist)
INSTALL_USER="ubuntu"
# The hostname of the server being installed.
SERVER_HOSTNAME="52.5.42.55"
# AWS Elastic IP pointing to $SERVER_HOSTNAME
AWS_ELASTIC_IP="eipalloc-fe64959a"
# RAILS_ENV to run under: "development" or "production"
APP_ENV="development"
# Name of Sufia Solr core
SOLR_CORE="$APP_ENV"
INSTALL_DIR="/home/$INSTALL_USER"
# Where the Hydra head will be located.
HYDRA_HEAD_DIR="$INSTALL_DIR/$HYDRA_HEAD"
# The directory in which the Fedora data lives
FEDORA4_DATA="$INSTALL_DIR/fedora-data"
DB_USER="$INSTALL_USER"
RUN_AS_INSTALLUSER="sudo -H -u $INSTALL_USER"
# AWS key pair used to connect to new instance
AWS_KEY_PAIR="data_repo"
# The AMI to be used for the newly-created AWS instance
AWS_AMI="ami-d05e75b8"
# The size in GB of the AWS instance EBS storage
AWS_EBS_SIZE="16"
# The type of AWS instance to use
AWS_INSTANCE_TYPE="t2.medium"
# The security groups to attach, e.g., to allow network access
AWS_SECURITY_GROUP_IDS="sg-55159632 sg-e5149782"
# AWS subnet in which to launch instance
AWS_SUBNET_ID="subnet-ec703bb5"
