#!/usr/bin/env bash
set -x
#./apply_custom.sh
docker-compose stop
docker-compose rm -f
docker-compose up