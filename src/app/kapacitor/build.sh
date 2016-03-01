#!/usr/bin/env bash
DOCKERFILE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t fvigotti/app-kapacitor $DOCKERFILE_DIR'/src'