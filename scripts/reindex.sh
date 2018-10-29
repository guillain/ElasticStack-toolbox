#!/bin/bash

LOCAL_USER='devops'
LOCAL_PASS='MyDev0ps!'
LOCAL_URL='https://7a764179163543f5825d75761d7017a6.eu-central-1.aws.cloud.es.io:9243'
LOCAL_INDEX='bonsai'
PREFIX='temp'

REMOTE_INDEX='temp'
REMOTE_USER=''
REMOTE_PASS=''
REMOTE_URL='http://54.37.9.161:9200'

request() {
  if [ "${1}" == "local" ]; then
    user=${LOCAL_USER}
    pass=${LOCAL_PASS}
    url=${LOCAL_URL}
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
index_lst=`request "local" "GET" "/_cat/indices/${LOCAL_INDEX}-*" | awk '{print $3}'`

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
request "local" "DELETE" "${LOCAL_INDEX}-*" ""

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
