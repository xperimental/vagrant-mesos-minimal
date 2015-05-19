#!/bin/bash

# Install docker
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker vagrant

# Setup keys for mesosphere
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update

# Install mesos & marathon
sudo apt-get -y install mesos marathon

# Configure Zookeeper
sudo service zookeeper stop
echo 1 | sudo tee /etc/zookeeper/conf/myid
sudo service zookeeper start

# Configure Mesos
echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers
echo '5mins' | sudo tee /etc/mesos-slave/executor_registration_timeout
