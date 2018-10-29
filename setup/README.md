# Elastic stack setup
Pre-settings to configure the Elastic Stack (after its initial installation)

Provide set of configuration files for:
* Elasticsearch indexing
* Logstash data collect and treatment
* Filebeat template to transfert your logs to logstash
* Kibana visualization, filter and dashboard

## Security
To ensure the security without the x-pack extra licence, SearchGuard is used and specific note file can be found on the following liink:
* https://github.com/guillain/notes/blob/master/ELK_SearchGuard.txt

Search Guard will increase the security and add AUTH and TLS methode.
At this moment only the montioring is not fully secured as HTTP  only is allowed on this module (re-only ^^).

## Design 
Best Practice for _real usage_

Repartition by Virtual Machine/Docker
0/ Source
* _Install:_ filebeat, syslog (UDP), JSON/TCP
* _What:_ Dedicated VM where the data source is/come from

1/ Data collection
* _Install:_ logstash
* _What:_ Collect all sources, index and push it to elasticsearch

2/ Index
* _Install:_ elasticsearch
* _What:_ Store and index the data

3/ Display
* _Install:_ kibana
* _What:_ Provide web interface for analytics & ML reports

Nodes design and sizing are not seeing here.
Specific study must be done on your targeted environment to establish the nodes repartition and them sizing according to the role that they will have.
Example if you need to provide high search performance it can be interesting to separate the node in charge of and increase its resources...

## Versions
This package is an old update coming from the 2.4 versions and today run on 6.4 cluster.
Some previous configuration has been kept and it's generally when it's a major change.

## Installation (fast method)
Target path is done for standard package deployment done via the Linux package management tool (as yum, apt...).
So if your settings are not in '/etc/x' thanks to adapt to your environment...

### Elasticsearch
`cp elasticsearch/*yml /etc/elasticsearch/`

### Kibana
`cp filebeat/* /etc/filebeat/`

### Logstash
`\cp -fr logstash/* /etc/logstash/`

### Filebeat
`cp filebeat/* /etc/filebeat/`

## Configuration
Preconfigured files have been provided to be used as-it-is for a all-in-one server.
The instance should follow this settings:
* elasticsearch with 4GB dedicated memory
* logstash with 2GB dedicated memory

PS: the memory is configured in the *jvm.options* file.
PS: a factor 2 should be considered in total for the system+app

The configuration is done without the licensed features and so without the necessary security.
Up to you to activate the ES security according to your license. An example of securisation is done with SearchGuard.

### Elasticsearch
Global file to manage the elasticsearch indexer according to the logstash and filebeat env to set.
You have 2 templates and you must choose one of them depending of you want to use Search Guard or not.
* With the standard security to activate: [elastic/elasticsearch.yml](elastic/elasticsearch.yml)
* With Search Guard security: [elastic/elasticsearch-searchguard.yml](elastic/elasticsearch-searchguard.yml)

### LogStash
Lot of filters are ready and just you need to adapt your input (connectors) according to your systems.

The configuration files have been recorded in a dedicated folder according to them usage:
* [logstash/conf.d/1-input](logstash/conf.d/1-input)
* [logstash/conf.d/2-filter](logstash/conf.d/2-filter)
* [logstash/conf.d/3-output](logstash/conf.d/3-output)

#### Input
* [logstash/conf.d/1-input/syslog.conf](logstash/conf.d/1-input/syslog.conf) : UDP/5000
* [logstash/conf.d/1-input/beats.conf](logstash/conf.d/1-input/beats.conf) : TCP/5044
* [logstash/conf.d/1-input/bot.conf](logstash/conf.d/1-input/bot.conf) : TCP/5055

#### Filter
Most of them with based on the patterns included in the logstash-patterns-core distribution.
Remember to adapt the clientip if you want to use the map, (geo)location...
* [logstash/conf.d/2-filter/syslog.conf](logstash/conf.d/2-filter/syslog.conf)
* [logstash/conf.d/2-filter/beats.conf](logstash/conf.d/2-filter/beats.conf)
* [logstash/conf.d/2-filter/syslog.conf](logstash/conf.d/2-filter/syslog.conf)
* [logstash/conf.d/2-filter/apache.conf](logstash/conf.d/2-filter/apache.conf)
* [logstash/conf.d/2-filter/audit.conf](logstash/conf.d/2-filter/audit.conf)
* [logstash/conf.d/2-filter/login.conf](logstash/conf.d/2-filter/login.conf)
* [logstash/conf.d/2-filter/bot.conf](logstash/conf.d/2-filter/bot.conf)
* [logstash/conf.d/2-filter/redis.conf](logstash/conf.d/2-filter/redis.conf)
* [logstash/conf.d/2-filter/aws.conf](logstash/conf.d/2-filter/aws.conf)
* [logstash/conf.d/2-filter/cisco.conf](logstash/conf.d/2-filter/cisco.conf)
* [logstash/conf.d/2-filter/mongodb.conf](logstash/conf.d/2-filter/mongodb.conf)
* [logstash/conf.d/2-filter/nagios.conf](logstash/conf.d/2-filter/nagios.conf)
* [logstash/conf.d/2-filter/java.conf](logstash/conf.d/2-filter/java.conf)
* [logstash/conf.d/2-filter/haproxy.conf](logstash/conf.d/2-filter/haproxy.conf)
* [logstash/conf.d/2-filter/ruby.conf](logstash/conf.d/2-filter/ruby.conf)
* [logstash/conf.d/2-filter/netscreen.conf](logstash/conf.d/2-filter/netscreen.conf)
* [logstash/conf.d/2-filter/sharewall.conf](logstash/conf.d/2-filter/sharewall.conf)
* [logstash/conf.d/2-filter/postgresql.conf](logstash/conf.d/2-filter/postgresql.conf)
* [logstash/conf.d/2-filter/rails.conf](logstash/conf.d/2-filter/rails.conf)
* [logstash/conf.d/2-filter/bro.conf](logstash/conf.d/2-filter/bro.conf)
* [logstash/conf.d/2-filter/cucmcdr.conf](logstash/conf.d/2-filter/cucmcdr.conf)

#### Output
Elasticsearch only at this time... to be continued.
Remember to adapt the `elasticsearch.conf` output file according to your ES.
* [logstash/conf.d/3-output/elasticsearch.conf](logstash/conf.d/3-output/elasticsearch.conf)
* [logstash/conf.d/3-output/debug.conf](logstash/conf.d/3-output/debug.conf)

#### Installation example on Logstash server
```bash
git clone https://github.com/guillain/ElasticSearch-toolbox
\cp -fr ElasticSearch-toolbox/conf/logtash/* /etc/logstash/conf.d/
systemctl restart logstash
```

### FileBeat
Provide log template to quickly integrate on your host where the data should come.
* syslog
* audit
* redis
* apache
* apache-other-vhost
* apache-error
* dpkg
* cucm-cdr
* cucm-cmr
* bot: based on JSON and dynamic index

#### Installation example on CentOS server to be collected with Filebeat
```bash
git clone https://github.com/guillain/ElasticSearch-toolbox
cp ElasticSearch-toolbox/conf/filebeat/* /etc/filebeat/
systemctl restart filebeat
```

## Cisco CDR/CMR
I've not integrated the mecanism to get the CDR/CMR from the CUCM, up to you to add your choice.
FYI on my side I use the same mechanism than for the log files.
In that case you can use the same design and tools to manage your log files and CDR/CMR files coming from your Unified Communication environment and also from your Visio Conferencing system.
PS it's time to open your S3 or Glacier to make it as permanent application backup...

### Cisco TMS CDR/CMR
Job ongoing

### Cisco CMS CDR/CMR
Job ongoing

### Cisco CUCM CDR/CMR
Thanks to [Damienetwork](https://damienetwork.wordpress.com) and its [website](https://damienetwork.wordpress.com/2015/10/09/elk-setup-for-cucm-cdr/).
At this time validated only for the Cisco CUCM (Call Manager) for these version:
* 6
* 8
* 10

### ToDo list
* Install logstash-filter-translate in Logstash
* Import JSON in elasticsearch and kibana (to find in the Damien's site)
* Finalize the TMS CDR integration
* Provide the file manager scripts

## GeoIP
Thanks to:[manicas](https://www.digitalocean.com/community/users/manicas) and its [article](https://www.digitalocean.com/community/tutorials/how-to-map-user-location-with-geoip-and-elk-elasticsearch-logstash-and-kibana)

[GeoIP](http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz) is included in apache and syslog conf...
* To continue in other configuration
* Or can declared as generic field under 'clientip' name

## Kibana
Principle:
* Unarchive the package
* Copy the content in your logstash configuration folder
* Adapt the conf to your elasticseaerch server in the 3xx output 
* Download the GeoIP database
* Install the CUCM CDR/CDR features

## Configuration validated
### Input
* syslog
* filebeat
* * syslog
* * auditlog
* * apache
* * CUCM CDR/CRM
* * CUCM/TMS logs
* logstash
* NodeJS bot
* Python bot
### Filter
* syslog
* apache
* audit
* login
* bot
### Ouput
* logstash
* elasticsearch
* redis

## Have fun :)
