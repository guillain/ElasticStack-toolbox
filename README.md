# ElasticStack-toolbox
Provide a set of configuration and tools to jump quickly in Elastic stack.

## Scripts
Some useful tools to manage ES.

[scripts/README.md](scripts/README.md)

## Setup
Set of configuration for the main component of the Elastic stack:
* elasticsearch
* logstash
* filebeat
* kibana

[setup/README.md](setup/README.md)

## Tools

### Syslog-NG
Syslog-ng configuration file is provided according to the data folder structure used in the setup.
The idea is to centralize the logs coming from all sources via a centralized syslog server.
`tools/syslog-ng.conf`

## Thanks
Thanks in advance to comment, improve, fork, PR... :-D
And have fun :-)