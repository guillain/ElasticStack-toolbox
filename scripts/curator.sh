#!/bin/bash
# https://www.elastic.co/blog/hot-warm-architecture

. ./config.sh

if [ "${1}" != "" ]; then RETENTION_DAY="${1}"; fi
if [ "${1}" == "" ]; then
    echo "curator.sh {RETENTION_DAY}"
    exit 0
fi

/usr/bin/curator --logfile /var/log/curator.log --loglevel INFO --logformat default --master-only --host localhost --port 9200 allocation --rule box_type=warm indices --time-unit days --older-than ${RETENTION_DAY} --timestring '%Y.%m.%d'
/usr/bin/curator --host localhost --port 9200 optimize indices --older-than ${RETENTION_DAY} --time-unit days  --timestring '%Y.%m.%d'

exit 1