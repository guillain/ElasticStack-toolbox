#!/bin/bash

# Firewall settings
firewall-cmd --permanent --add-port=514/tcp
firewall-cmd --permanent --add-port=514/udp
firewall-cmd --reload

# Package dependcies coming from the CDROM repository
yum -y --disablerepo=\* --enablerepo=c7-media install libnet libnet-dev

# Installation that's include:
# - filebeat binary
# - syslog-ng to centralize the log
# - additional required libraries for the previous binaries
yum -y install syslog-ng

# Initialize the global data folder
## External log files (infra, app...) 
## final structure mgt by syslog-ng: /home/data/servers/YYYY.MM.DD/HOSTNAME
mkdir /home/data/servers

## CDR/CMR folder define by source 
mkdir /home/data/cdr_cmr/cucm/EMEA_1
mkdir /home/data/cdr_cmr/cucm/EMEA_2
mkdir /home/data/cdr_cmr/cucm/SME
mkdir /home/data/cdr_cmr/cucm/AMER
mkdir /home/data/cdr_cmr/cucm/APAC

mkdir /home/data/cdr_cmr/vcs/EMEA_B2B_1
mkdir /home/data/cdr_cmr/vcs/EMEA_B2B_2
mkdir /home/data/cdr_cmr/vcs/AMER_B2B
mkdir /home/data/cdr_cmr/vcs/APAC_B2B
mkdir /home/data/cdr_cmr/vcs/EMEA_TEL
mkdir /home/data/cdr_cmr/vcs/EMEA_FED
mkdir /home/data/cdr_cmr/vcs/AMER_TEL
mkdir /home/data/cdr_cmr/vcs/APAC_TEL

mkdir /home/data/cdr_cmr/cms/WWW
mkdir /home/data/cdr_cmr/cms/FED

# Initialisation the app with pre-configured files
mv /etc/syslog-ng.conf /etc/syslog-ng.conf.orig
cp syslog-ng.conf /etc/syslog-ng.conf
echo "Thanks to adapt the local IP@ in the conf file: /etc/syslog-ng.conf"

# Syslog-ng as service with auto startup
systemctl disable rsyslog.service
systemctl disable syslog.socket
systemctl stop rsyslog.service
systemctl stop syslog.socket

systemctl enable syslog-ng.service
systemctl start syslog-ng.service
systemctl | grep syslog


exit 0