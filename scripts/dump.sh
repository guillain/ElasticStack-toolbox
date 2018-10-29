#!/bin/bash

. ./config.sh
# npm install elasticdump

if [ "${1}" != "" ]; then INDEX_SOURCE="${1}"; fi
if [ "${2}" != "" ]; then URL_SOURCE="${2}"; fi
if [ "${3}" != "" ]; then URL_DEST="${3}"; fi

if [ "${1}" == "" ] || [ "${2}" == "" ] || [ "${3}" == "" ]; then
    echo "dump.sh {INDEX_SOURCE} {URL_SOURCE} {URL_DEST}"
    exit 0
fi

for index in `curl -X GET "http://${URL_SOURCE}:9200/_cat/indices?v=&pretty=" | grep "${INDEX_SOURCE}" | awk '{print $3}' | sort -u`; do
	echo "index: $index";
	elasticdump --input=http://${URL_SOURCE}:9200/${index} --output=http://${URL_DEST}:9200/${index} --type=data
done


