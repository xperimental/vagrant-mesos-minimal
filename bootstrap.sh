#!/bin/bash -e

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
echo 'local-mesos' | sudo tee /etc/mesos-master/cluster
echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers
echo '5mins' | sudo tee /etc/mesos-slave/executor_registration_timeout

# Configure Marathon
sudo mkdir -p /etc/marathon/conf
echo 'http_callback' | sudo tee /etc/marathon/conf/event_subscriber

# Install HAProxy
echo deb http://archive.ubuntu.com/ubuntu trusty-backports main universe | \
  sudo tee /etc/apt/sources.list.d/backports.list
sudo apt-get update
sudo apt-get install haproxy -t trusty-backports
sudo cp /vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo service haproxy reload

# Install bamboo
sudo tar -xvzf /vagrant/bamboo-0-2-11.tar.gz -C /usr/local/
sudo mkdir -p /etc/bamboo/
sudo cp /vagrant/bamboo.conf /vagrant/haproxy_template.cfg /etc/bamboo/
sudo cp /vagrant/bamboo.init /etc/init/bamboo.conf

# Download registry
sudo docker pull registry

# Start everything
sudo service mesos-master start
sudo service mesos-slave start
sudo service marathon start
sudo service bamboo start
sudo docker run --name registry --restart=always -p 5000:5000 -d registry
