# ElasticStack-toolbox
Provide a set of configuration and tools to jump quickly in Elastic stack.
Deployment and configuration support provided by scripts and templatce of configuration files.
* OS:
  * VM
  * Docker
  * Cloud instance
* Application:
  * Full Elastic stack: Elasticsearch, Logstash, Kibana, Filebeat
  * Additional tool like syslog-ng to centralize the log
  * Management tools for the stack (reindex, duplicate, mapping...)

## Elastic stack setup
Two deployment scenarios and each one is provided with VM and docker methods:

1 - VM
2 - Docker

Set up the OS and install and configure the main components of the Elastic stack.
Each of them is provided with a bash script and set of configuration files ready to use or at least to adapt for a specific production environment.
* [Elasticsearch](elasticsearch)
  * [Single-node](elasticsearch/single-node)
  * [Hot-Warm](elasticsearch/hot_warm)
* [Logstash](logstash)
  * [Pre-configured files for input, filter and output](logstash/conf.d/)
* [Filebeat](filebeat)
* [Kibana](kibana)

You will find all details in this [README](ES_README.md) file.

## [Syslog-NG](syslog-ng)
Syslog-ng configuration file is provided according to the data folder structure used in the setup.
The idea is to centralize the logs coming from all sources via a centralized syslog server.

## [Scripts](scripts)
Some useful tools to manage ES.
To be more efficient during the ES operation *reindexer*, "cloner*,... tools are provided under bash script.
* scripts/

You will find all details in this [README](scripts/README.md) file.

## [csr](csr)
How to generate all CSR and the associated key in one shot? foolow this script ;-)

## ToDo list
* Install logstash-filter-translate in Logstash
* Json diffusion as template
* Import JSON in elasticsearch and kibana (to complie and complete from the Damien's site)
* Provide additional elasticsearch *template*
* Finalize the Cisco TMS/CMS CDR/CMR integration
* Provide the bash scripts to manage the files vs archives in syslog-ng (backup.sh/clean.sh)
* Add _curator_ to the docker env

## Thanks
Thanks in advance to comment, improve, fork, PR... :-D
And have fun :-)

