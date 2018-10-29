#!/bin/bash

# Add the following to the remote Elasticsearch node
# reindex.remote.whitelist: ['LOCAL_URL']

LOCAL_USER='devops'
LOCAL_PASS='MyDev0ps!'
LOCAL_URL='https://7a764179163543f5825d75761d7017a6.eu-central-1.aws.cloud.es.io:9243'
LOCAL_INDEX=''

REMOTE_INDEX='iot'
REMOTE_USER=''
REMOTE_PASS=''
REMOTE_URL='http://54.37.9.161:9200'

request() {
  if [ "${1}" == "local" ]; then
    user=${LOCAL_USER}
    pass=${LOCAL_PASS}
    url="${LOCAL_URL}/${3}"
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
    \"index\": \"${LOCAL_INDEX}${index}\"
  }
}"
  request "local" "POST" "/_reindex" "${conf}"
done

exit 0
