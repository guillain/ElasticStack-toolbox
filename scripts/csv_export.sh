#!/bin/bash
# pip install es2csv

. ./config.sh

if [ "${1}" != "" ]; then INDEX_SOURCE="${1}"; fi
if [ "${2}" != "" ]; then URL_SOURCE="${2}"; fi
OUTPUT=${3}
FILTER=${4}

if [ "${1}" == "" ] || [ "${2}" == "" ] || [ "${3}" == "" ] || [ "${4}" == "" ]; then
    echo "csv_export {INDEX_SOURCE} {URL_SOURCE} {OUTPUT} {FILTER}"
    exit 0
fi

echo "Running..."
es2csv 	-i ${INDEX_SOURCE}-* \
	-q '*' \
	-u ${URL_SOURCE} \
	-o ${OUTPUT} \
	-f ${FILTER}
echo "Done"
