#!/bin/bash

# Firewall settings
firewall-cmd --permanent --add-port=5044/tcp
firewall-cmd --reload

# Logstash installation
yum -y install logstash

# Initialisation the app with pre-configured files
mv /etc/logstash/logstash.yml /etc/logstash/logstash.yml.orig
mv /etc/logstash/jvm.options /etc/logstash/jvm.options.orig
\cp -fr * /etc/logstash/

# Logstash as service with auto startup
systemctl restart logstash.service && tail -f  /var/log/logstash/logstash-plain.log

exit 0