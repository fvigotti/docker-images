#!/bin/bash
set -xe

stop_and_delete_container(){
    echo 'stop and remove previously tested container :'$1' if exits..'
    docker stop "$1" || true
    docker rm -f "$1" || true
}


export ROOT_PATH_DISTANCE='../../../'
export BASE_IMAGE_PATH='src/webserver/nginx-supervisor/'
export IMAGE_NAME='webserver-nginx-supervisor'

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



docker build -t "${OUTPUT_IMAGENAME}" $ABSOLUTE_IMAGE_PATH

# cp -Rfp $TEST_CURRENT_DIR/data/ /tmp/docker_nginx_test/

echo 'copying test files into temp destination >> '$TEST_TEMP_DIR
# --delete-after
rsync -acv  $TEST_CURRENT_DIR/data/ "${TEST_TEMP_DIR}/"


#exit 0 ;

export NGINX_HTTP_PORT=80
export PROXYED_HTTP_PORT=18089
export DOCKER_DAEMON_OPTIONS="-d"
# export DOCKER_DAEMON_OPTIONS="--rm -ti"


stop_and_delete_container $TEST_CONTAINER_NAME

docker run ${DOCKER_DAEMON_OPTIONS} --name ${TEST_CONTAINER_NAME} \
-v "${TEST_TEMP_DIR}/"cache/:/var/cache/nginx/   \
-v "${TEST_TEMP_DIR}/"logs/:/data/logs/   \
-v "${TEST_TEMP_DIR}/"www/:/data/http/   \
-p ${PROXYED_HTTP_PORT}:${NGINX_HTTP_PORT} \
 "${OUTPUT_IMAGENAME}"
#-v "${TEST_TEMP_DIR}/"/etc/:/etc/nginx/   \
#-v /tmp/docker_nginx_test/shared_volumes/logs/:/var/log/nginx/   \
#-p ${NGINX_HTTP_PORT}:${NGINX_HTTP_PORT} \
#-p ${PROXYED_HTTP_PORT}:${PROXYED_HTTP_PORT} \
sleep 2;
TEST_RESULTS=$(curl --silent "http://127.0.0.1:${PROXYED_HTTP_PORT}" )

echo 'TEST_RESULTS = '$TEST_RESULTS

TEST_RESULTS_secondpage=$(curl --silent "http://127.0.0.1:${PROXYED_HTTP_PORT}/secondPage.html" )
echo 'TEST_RESULTS_secondpage = '$TEST_RESULTS_secondpage

exit 0;

stop_and_delete_container $TEST_CONTAINER_NAME



