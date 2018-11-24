#!/bin/bash

# Add the following to the remote Elasticsearch node
# reindex.remote.whitelist: ['URL_SOURCE']

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
    url="${URL_SOURCE}/${3}"
  elif [ "${1}" == "remote" ]; then
    user=${REMOTE_USER}
    pass=${REMOTE_PASS}
    url="${REMOTE_URL}/${3}"
  fi

  auth=""
  if [ "${user}" != "" ] && [ "${pass}" != "" ]; then auth="-u${user}:${pass}"; fi

  if [ "${4}" != "" ]; then
    curl ${auth} -X ${2} ${url} -H "Content-Type: application/json" -d "${4}"
  else
    curl ${auth} -X ${2} ${url} -H "Content-Type: application/json"
  fi
}

# Get list of index
#index_lst=`request "remote" "GET" "/_cat/indices/${REMOTE_INDEX}-*" "" | awk '{print $3}'`
index_lst=`curl -X GET ${REMOTE_URL}/_cat/indices/${REMOTE_INDEX}-* | awk '{print $3}'`
echo -e "List of index:\n${index_lst}"

# For each index duplicate it in the new index 
# PS. hopefuly you already have an ES template to reformat your field...
for index in ${index_lst}; do
  conf="
{
  \"source\": {
    \"index\": \"${index}\",
    \"remote\": {
      \"host\": \"${REMOTE_URL}\",
      \"username\": \"${REMOTE_USER}\",
      \"password\": \"${REMOTE_PASS}\"
    }
  },
  \"dest\": {
    \"index\": \"${INDEX_SOURCE}${index}\"
  }
}"
  request "local" "POST" "/_reindex" "${conf}"
done

exit 0
