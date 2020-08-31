#!/bin/bash
#
# aliyun mirrors
# daocloud mirrors
#

# check root user
check_root() 
{
  if [ ! $( id -u ) -eq 0 ]; then
    echo "Please run this script using root user."
    exit -1;
  fi
}
# check root user
check_root

# backups
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
# use aliyun mirrors
sudo sed -i 's:archive.ubuntu.com:mirrors.aliyun.com:g' /etc/apt/sources.list

# update source cache
apt-get update

# install depends
apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# add key
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

# add source
add-apt-repository "deb [arch=$(dpkg --print-architecture)] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# update source cache
apt-get -y update
# install docker-ce
apt-get -y install docker-ce

# install docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

# config docker china sources
touch /etc/docker/daemon.json

cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors" : [
    "https://dockerhub.azk8s.cn",
    "https://reg-mirror.qiniu.com",
    "http://docker.mirrors.ustc.edu.cn",
    "http://hub-mirror.c.163.com"
  ]
}
EOF

# restart docker daemon
service docker restart
