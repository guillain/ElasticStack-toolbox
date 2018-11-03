#!/bin/bash

C="FR"
ST="Toulouse"
L="Garage"
O="Free"
OU="Free"

CSR_DIR="./data"

FQDNs="ADDRIP_MASTER_1 ADDRIP_ML_1 ADDRIP_KIBANA ADDRIP_LOGSTASH ADDRIP_SYSLOG-NG"
#FQDNs="ADDRIP_MASTER_1 ADDRIP_MASTER_2 ADDRIP_MASTER_3 ADDRIP_ML_1 ADDRIP_HOT_1 ADDRIP_HOT_2 ADDRIP_HOT_3 ADDRIP_WARM_1 ADDRIP_WARM_2 ADDRIP_WARM_3 ADDRIP_KIBANA ADDRIP_LOGSTASH ADDRIP_SYSLOG-NG"

# Functions ----------------------------
# $1: FQDN
gene_csr(){
    openssl genrsa -out "${CSR_DIR}/${1}.key" 2048
    openssl req -new -key "${CSR_DIR}/${1}.key" -out "${CSR_DIR}/${1}.csr" -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${1}"
}

# Main ---------------------------------
if [ ! -d ${CSR_DIR} ]; then mkdir ${CSR_DIR}; fi

for fqdn in ${FQDNs}; do
    gene_csr "${fqdn}"
done

exit 0
