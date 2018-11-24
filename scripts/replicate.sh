#!/bin/bash

. ./config.sh

if [ "${1}" != "" ]; then INDEX_SOURCE="${1}"; fi
if [ "${2}" != "" ]; then URL_SOURCE="${2}"; fi
if [ "${3}" != "" ]; then NBR_OF_REPLICAT="${3}"; fi

if [ "${1}" == "" ] || [ "${2}" == "" ] || [ "${3}" == "" ]; then
    echo "replicate.sh {INDEX_SOURCE} {URL_SOURCE} {NBR_OF_REPLICAT}"
    exit 0
fi

for index in `curl -XGET ${URL_SOURCE}/_cat/shards?h=index,shard,prirep,state,unassigned.reason \
| grep "${INDEX_SOURCE}" \
| awk '{print $1}' \
| sort -u`; do
	echo -n "${index} : "
	curl -XPUT "${URL_SOURCE}/${index}/_settings" -H 'Content-Type: application/json' -d'
	{
	   "index" : {
		   "number_of_replicas" : 0
	   }
	}'
done
