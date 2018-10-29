# Elastic Stack Management
Tools to manage easily your Elastic stack environment

## Features

### Dump
Use the script `dump.sh` to dump an index over the network, locally, on another index, es...
Up to you to adapt it to clone locally but you have another script for that ;-)
This include the sub-index created during the data importand the definition that you can do on it.
`./dump.sh {INDEX_SOURCE} {URL_SOURCE} {URL_DEST}`
ie.:
`./dump.sh toto 10.0.0.10 10.0.1.10`
* toto-2018.01.01
* toto-2018.01.02

*Requirements*
* npm install elasticdump

### Reindex

### Replicate
Change *replicate* settings on sepcific index (and sub-index).
`./replicate.sh {INDEX_SOURCE} {URL_SOURCE} {NBR_OF_REPLICAT}`

### CSV Export
Export an index (and sub-index) to CSV file.
To improve performance, select the fields that you need via the filter.
`./csv_export.sh {INDEX_SOURCE} {URL_SOURCE} {OUTPUT} {FILTER}`

*Requirements*
* pip install es2csv

### Curator
Run curator program locally on ES master.
`./curator.sh {RETENTION_DAY}`
