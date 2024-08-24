
#!/bin/bash

##########################################################
# Author : Tharmika Ravichandran
# Date   : 24.8.2024
#
# This script helps the user to install all the nessasry tools to run 
# the magma-core backend and DMS frontend application.
#
#
# Operating System : CentOS Linux 7 (Core)
# Kernel           : Linux 3.10.0-1160.45.1.el7.x86_64
# Architecture     :  x86-64
#
###########################################################


set -e
set -u
set -x

# update the system packages
echo "Updating system packages"
sudo yum update -y

# install git and nginx
echo "Install Git and Nginx"
sudo yum install -y git nginx

# install java and maven
echo "Install Java and Maven for Magma-core backend"
sudo yum install -y java-1.8.0-openjdk maven

# install mongo and enable the service
echo "Install MongoDB 5.0 for Magma-core backend"
sudo tee /etc/yum.repos.d/mongodb-org.repo > /dev/null <<EOF
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF

sudo yum install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

# install vernemq
echo "Install VerneMQ"
sudo yum install -y wget
wget -P /root https://github.com/vernemq/vernemq/releases/download/1.12.4/vernemq-1.12.4.centos7.x86_64.rpm
sudo yum update -y
sudo yum install -y /root/vernemq-1.12.4.centos7.x86_64.rpm

sleep 5

sudo sed -i 's/^listener.tcp.default.*/listener.tcp.default = 0.0.0.0:1883/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^listener.ws.default.*/listener.ws.default = 127.0.0.1:8000/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^accept_eula = no/accept_eula = yes/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^plugins.vmq_diversity = off/plugins.vmq_diversity = on/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^plugins.vmq_passwd = on/plugins.vmq_passwd = off/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^plugins.vmq_acl = on/plugins.vmq_acl = off/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^vmq_diversity.auth_mongodb.enabled = off/vmq_diversity.auth_mongodb.enabled = on/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^## vmq_diversity.mongodb.host = localhost/vmq_diversity.mongodb.host = localhost/' /etc/vernemq/vernemq.conf
sudo sed -i 's/^## vmq_diversity.mongodb.database =.*/vmq_diversity.mongodb.database = senzagro/' /etc/vernemq/vernemq.conf
sudo sed -i 's/## vmq_diversity.mongodb.port = 27017/vmq_diversity.mongodb.port = 27017/' /etc/vernemq/vernemq.conf

sudo systemctl restart vernemq
sudo systemctl enable vernemq


echo "Install nvm to build dms frontend"
curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash
source ~/.bash_profile
nvm install v16.15.0
node --version
