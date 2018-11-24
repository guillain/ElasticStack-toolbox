#!/bin/bash

# Installation
yum -y install filebeat

# App as service with auto startup
chkconfig --add filebeat
systemctl daemon-reload
systemctl enable filebeat.service

# Initialisation the app with pre-configured files
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
cp filebeat.yml /etc/filebeat/filebeat.yml
echo "Thanks to adapt the local IP@ in the conf file: /etc/syslog-ng.conf"

# App as service
systemctl start filebeat.service

exit 0