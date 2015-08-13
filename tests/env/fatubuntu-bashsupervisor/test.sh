#!/bin/bash
set -xe

stop_and_delete_container(){
    echo 'stop and remove previously tested container :'$1' if exits..'
    docker stop "$1" || true
    docker rm -f "$1" || true
}

export ROOT_PATH_DISTANCE='../../../'
export BASE_IMAGE_PATH='src/env/fatubuntu-bashsupervisor/'
export IMAGE_NAME='fatubuntu-bashsupervisor'

export OUTPUT_IMAGENAME="fvigotti/${IMAGE_NAME}"

export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo 'TEST_CURRENT_DIR = '$TEST_CURRENT_DIR

export PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")" && cd ${ROOT_PATH_DISTANCE} && pwd )
echo 'PROJECT_ROOT = '$PROJECT_ROOT

export ABSOLUTE_IMAGE_PATH=$(readlink -e "${PROJECT_ROOT}/${BASE_IMAGE_PATH}/")'/'
echo 'ABSOLUTE_IMAGE_PATH = '$ABSOLUTE_IMAGE_PATH

export TEST_TEMP_DIR="/tmp/docker/${IMAGE_NAME}/"
echo 'TEST_TEMP_DIR= '$TEST_TEMP_DIR
mkdir -p $TEST_TEMP_DIR


export TEST_CONTAINER_NAME='test_'${IMAGE_NAME}

cd $PROJECT_ROOT

echo 'copying test files into temp destination >> '$TEST_TEMP_DIR
# --delete-after
rsync -acv  "${TEST_CURRENT_DIR}/data/" "${TEST_TEMP_DIR}/"

chmod +x ${TEST_TEMP_DIR}/config/*
chmod +x ${TEST_TEMP_DIR}/app/*

docker build -t "${OUTPUT_IMAGENAME}" $ABSOLUTE_IMAGE_PATH

export DOCKER_DAEMON_OPTIONS="-d"
export DOCKER_DAEMON_OPTIONS="--rm -ti"

stop_and_delete_container $TEST_CONTAINER_NAME

echo '###########################################################################'
echo 'starting container in interactive mode, press CTRL+C and see that the main app should receive termination signal!'

docker run ${DOCKER_DAEMON_OPTIONS} --name ${TEST_CONTAINER_NAME} \
-v "${TEST_TEMP_DIR}/"config/init20-launch-app.sh:/config/init20-launch-app.sh   \
-v "${TEST_TEMP_DIR}/"app:/app   \
"${OUTPUT_IMAGENAME}"
#--env "DEBUG=1"  \

exit 0;

stop_and_delete_container $TEST_CONTAINER_NAME


