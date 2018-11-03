#!/bin/bash

PREFIX='temp'

if [ "${1}" != "" ]; then INDEX_SOURCE="${1}"; fi
if [ "${2}" != "" ]; then URL_SOURCE="${2}"; fi
if [ "${3}" != "" ]; then LOCAL_USER="${3}"; fi
if [ "${4}" != "" ]; then LOCAL_PASS="${4}"; fi

if [ "${5}" != "" ]; then REMOTE_INDEX="${5}"; fi
if [ "${6}" != "" ]; then REMOTE_URL="${6}"; fi
if [ "${7}" != "" ]; then REMOTE_USER="${7}"; fi
if [ "${8}" != "" ]; then REMOTE_PASS="${8}"; fi

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

# Get list of index
index_lst=`request "local" "GET" "/_cat/indices/${URL_SOURCE}-*" | awk '{print $3}'`

# For each index duplicate it in the new index 
# PS. hopefuly you already have an ES template to reformat your field...
for index in ${index_lst}; do
  echo -E "index clone ${index} to ${PREFIX}-${index}"
  conf="
{
  \"source\": {
    \"index\": \"${index}\"
  },
  \"dest\": {
    \"index\": \"${PREFIX}-${index}\"
  }
}"
  request "local" "POST" "/_reindex" "${conf}"
  echo " Done"
done

echo "Press KEY if you're SURE to continue! It will remove original index: '${index}-*'"
read
echo "SURE...?!?!"
read

# Remove original index
request "local" "DELETE" "${URL_SOURCE}-*" ""

# Recreate original index from the duplicated
for index in ${index_lst}; do
  echo -E "index clone ${PREFIX}-${index} to ${index}"
  conf="
{
  \"source\": {
    \"index\": \"${PREFIX}-${index}\"
  },
  \"dest\": {
    \"index\": \"${index}\"
  }
}"
  request "local" "POST" "/_reindex" "${conf}"
  echo " Done"
done

exit 0
