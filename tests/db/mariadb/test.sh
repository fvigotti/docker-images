#!/bin/bash
set -xe
export ROOT_PATH_DISTANCE='../../../'
export BASE_IMAGE_PATH='src/db/mariadb/'
export IMAGE_NAME='db-mariadb'

export OUTPUT_IMAGENAME="fvigotti/${IMAGE_NAME}"

export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo 'TEST_CURRENT_DIR = '$TEST_CURRENT_DIR

export PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")" && cd ${ROOT_PATH_DISTANCE} && pwd )
echo 'PROJECT_ROOT = '$PROJECT_ROOT

export ABSOLUTE_IMAGE_PATH=$(readlink -e "${PROJECT_ROOT}/${BASE_IMAGE_PATH}/")'/'
echo 'ABSOLUTE_IMAGE_PATH = '$ABSOLUTE_IMAGE_PATH

#export TEST_TEMP_DIR="/tmp/docker/${IMAGE_NAME}/"
#echo 'TEST_TEMP_DIR= '$TEST_TEMP_DIR
#mkdir -p $TEST_TEMP_DIR
#echo 'copying test files into temp destination >> '$TEST_TEMP_DIR
#rsync -acv --delete $TEST_CURRENT_DIR/data/ "${TEST_TEMP_DIR}/"


export TEST_CONTAINER_NAME='test_'${IMAGE_NAME}

cd $PROJECT_ROOT



docker build -t "${OUTPUT_IMAGENAME}" $ABSOLUTE_IMAGE_PATH

# cp -Rfp $TEST_CURRENT_DIR/data/ /tmp/docker_nginx_test/


export DOCKER_DAEMON_OPTIONS="--rm -ti"


docker run ${DOCKER_DAEMON_OPTIONS} --name ${TEST_CONTAINER_NAME} \
 "${OUTPUT_IMAGENAME}"

exit 0;



