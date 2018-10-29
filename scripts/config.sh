#!/bin/bash

INDEX_SOURCE=shellbot #${1}
URL_SOURCE=10.240.184.12
URL_DEST=54.93.180.49

LOCAL_USER='devops'
LOCAL_PASS='MyDev0ps!'
LOCAL_URL='https://7a764179163543f5825d75761d7017a6.eu-central-1.aws.cloud.es.io:9243'
LOCAL_INDEX='bonsai'
PREFIX='temp'

REMOTE_INDEX='temp'
REMOTE_USER=''
REMOTE_PASS=''
REMOTE_URL='http://54.37.9.161:9200'

NBR_OF_REPLICAT=0
RETENTION_DAY=30

# Bot
FILTER="@timestamp @version from host level message spaceid spacename type"

# Shellbot
#FILTER="@timestamp @version bot channel_id clientip content from_id from_label host id input_type is_direct mentioneds_ids message personEmail personId roomId roomType source stamp text type"
