#!/bin/bash
set -xe

stop_and_delete_container(){
    echo 'stop and remove previously tested container :'$1' if exits..'
    docker stop "$1" || true
    docker rm -f "$1" || true
}

export ROOT_PATH_DISTANCE='../../../'
export BASE_IMAGE_PATH='src/env/jdk/'
export IMAGE_NAME='env-jdk'

export OUTPUT_IMAGENAME="fvigotti/${IMAGE_NAME}"

export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo 'TEST_CURRENT_DIR = '$TEST_CURRENT_DIR

export PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")" && cd ${ROOT_PATH_DISTANCE} && pwd )
echo 'PROJECT_ROOT = '$PROJECT_ROOT

export ABSOLUTE_IMAGE_PATH=$(readlink -e "${PROJECT_ROOT}/${BASE_IMAGE_PATH}/")'/'
echo 'ABSOLUTE_IMAGE_PATH = '$ABSOLUTE_IMAGE_PATH


export TEST_CONTAINER_NAME='test_'${IMAGE_NAME}

cd $PROJECT_ROOT



docker build -t "${OUTPUT_IMAGENAME}" $ABSOLUTE_IMAGE_PATH

export DOCKER_DAEMON_OPTIONS="-d"
export DOCKER_DAEMON_OPTIONS="--rm -ti"

stop_and_delete_container $TEST_CONTAINER_NAME

echo '###########################################################################'
echo 'starting container in interactive mode, press CTRL+C and see that the main app should receive termination signal!'

docker run ${DOCKER_DAEMON_OPTIONS} --name ${TEST_CONTAINER_NAME} \
--env "DEBUG=1"  \
"${OUTPUT_IMAGENAME}" /bin/bash -c "java -version"

exit 0;

stop_and_delete_container $TEST_CONTAINER_NAME


