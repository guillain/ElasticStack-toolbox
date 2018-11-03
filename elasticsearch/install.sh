#!/bin/bash

# ES data will be stored in the home partition,
# where the OS associate all available disk space:
# - for the ES data: /home/data/elasticsearch
# - for the ES log: /home/data/log

# Firewall settings
firewall-cmd --permanent --add-port=9200/tcp
firewall-cmd --permanent --add-port=9300/tcp
firewall-cmd --reload

# ES init
echo 'elasticsearch    -       nofile          65536' >> /etc/security/limits.conf
echo 'elasticsearch    -       nproc           4096' >> /etc/security/limits.conf
echo 'elasticsearch    soft    memlock         unlimited' >> /etc/security/limits.conf
echo 'elasticsearch    hard    memlock         unlimited' >> /etc/security/limits.conf

# ES Installation
yum -y install elasticsearch

# App as service with auto startup
chkconfig --add elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service

# Tuning (specific to lock memory)
echo 'MAX_OPEN_FILES=65536' >> /etc/sysconfig/elasticsearch
echo 'MAX_LOCKED_MEMORY=unlimited' >> /etc/sysconfig/elasticsearch
echo 'MAX_MAP_COUNT=262144' >> /etc/sysconfig/elasticsearch

# Copy specific files
echo "Thanks to copy/paste the necessary file according to your setup/env/node..."
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig
echo "cp ./elasticsearch_XXX_X.yml /etc/elasticsearch/elasticsearch.yml"
read
mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.orig
cp ./jvm.options /etc/elasticsearch/jvm.options

# Start the app
systemctl start elasticsearch.service && tail -f  /var/log/elasticsearch/*log

# Curator install
yum -y install elasticsearch-curator

# Curator
cp -fr curator /root/.curator
curator cdr_cmr
echo "todo: curator conf"

exit 0
