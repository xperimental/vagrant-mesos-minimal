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

# Install HAProxy
echo deb http://archive.ubuntu.com/ubuntu trusty-backports main universe | \
  sudo tee /etc/apt/sources.list.d/backports.list
sudo apt-get update
sudo apt-get install haproxy -t trusty-backports

# Install bamboo
sudo tar -xvzf /vagrant/bamboo-0-2-11.tar.gz -C /usr/local/
sudo mkdir -p /etc/bamboo/
sudo cp /vagrant/bamboo.conf /vagrant/haproxy_template.cfg /etc/bamboo/
sudo cp /vagrant/bamboo.init /etc/init/bamboo.conf
