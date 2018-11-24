#!/bin/bash

# OS initialization

## Remove swap partition
sed -i 'd/swap/' /etc/fstab

## Install dependencies and useful packages
yum -y install java vim zip unzip net-tools

## Settings the OS with the ES repository
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo "[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/elasticsearch.conf

# Update local package and the OS repository pkg listing
yum -y update

# End and drive
echo "
Thanks to initialize each instance with this script following by the dedicated script for the considered platform.
Recommended order:
1 - Elasticsearch
  - Installation of each master and data nodes with the dedicated configuration...
2 - Kibana
3 - logstash
4 - filebeat (with syslog-ng if need)
"

exit 0
