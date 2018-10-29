#!/bin/bash
# Curator v@3
# https://www.elastic.co/blog/hot-warm-architecture
/usr/bin/curator --logfile /var/log/curator.log --loglevel INFO --logformat default --master-only --host localhost --port 9200 allocation --rule box_type=warm indices --time-unit days --older-than 3 --timestring '%Y.%m.%d'
/usr/bin/curator --host localhost --port 9200 optimize indices --older-than 3  --time-unit days  --timestring '%Y.%m.%d'