#!/bin/bash

# Firewall settings
firewall-cmd --permanent --add-port=5601/tcp
firewall-cmd --reload

# Kibana installation
yum -y install kibana

# App as service with auto startup
chkconfig --add kibana
systemctl daemon-reload
systemctl enable kibana.service

# Initialisation the app with pre-configured files
mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.orig
cp ./kibana.yml /etc/kibana/kibana.yml

# Start the app
systemctl start kibana.service

exit 0