#!/bin/bash
set -xe
ROOT_PATH_DISTANCE='../../../'
BASE_IMAGE_PATH='src/env/jdk/'

APP_SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")" && cd ${ROOT_PATH_DISTANCE} && pwd )
echo 'PROJECT_ROOT = '$PROJECT_ROOT

ABSOLUTE_IMAGE_PATH=$(readlink -e "${PROJECT_ROOT}/${BASE_IMAGE_PATH}/")
echo 'ABSOLUTE_IMAGE_PATH = '$ABSOLUTE_IMAGE_PATH

cd $PROJECT_ROOT

docker build -t "fvigotti/env-fatubuntu" $ABSOLUTE_IMAGE_PATH
exit 0
