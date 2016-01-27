#!/usr/bin/env bash
DOCKERFILE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t fvigotti/app-zookeeper $DOCKERFILE_DIR'/src'