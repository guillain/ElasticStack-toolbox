#!/bin/bash

if [ "${1}" != "" ]; then INDEX_SOURCE="${1}"; fi # myindex
if [ "${2}" != "" ]; then URL_SOURCE="${2}"; fi # https://myelk:9243
if [ "${3}" != "" ]; then LOCAL_USER="${3}"; fi # myuser
if [ "${4}" != "" ]; then LOCAL_PASS="${4}"; fi # mypass
if [ "${5}" != "" ]; then PREFIX="${5}"; fi # backup
if [ "${6}" != "" ]; then FILTER="${6}"; fi # 2018

request() {
  if [ "${1}" == "local" ]; then
    user=${LOCAL_USER}
    pass=${LOCAL_PASS}
    url=${URL_SOURCE}
  elif [ "${1}" == "remote" ]; then
    user=${REMOTE_USER}
    pass=${REMOTE_PASS}
    url=${REMOTE_URL}
  fi

  if [ "${4}" != "" ]; then
    curl -X ${2} -u${user}:${pass} ${url}/${3} -H "Content-Type: application/json" -d "${4}"
  else
    curl -X ${2} -u${user}:${pass} ${url}/${3} -H "Content-Type: application/json"
  fi
}

if [ "${FILTER}" == "" ]; then FILTER="-"; fi

index_lst=`request "local" "GET" "_cat/indices/${PREFIX}-${INDEX_SOURCE}*" | awk '{print $3}' | grep ${FILTER} | sort`
for index in ${index_lst}; do
  echo -En "reindex ${index} to `echo ${index} | sed "s/^${PREFIX}-//g" `"
  conf="
{
  \"source\": {
    \"index\": \"${index}\"
  },
  \"dest\": {
    \"index\": \"`echo ${index} | sed "s/^${PREFIX}-//g"`\"
  }
}"
  request "local" "POST" "_reindex" "${conf}"
  echo " Done"
done

exit 0
