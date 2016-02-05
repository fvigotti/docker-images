#!/usr/bin/env bash
DOCKERFILE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t fvigotti/env-alpine:latest $DOCKERFILE_DIR'/src'