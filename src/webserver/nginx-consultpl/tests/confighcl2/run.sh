#!/usr/bin/env bash
set -xe
TEST_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOCKERFILE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../ && pwd )

export TEST_TEMP_DIR="/tmp/docker/revproxy1/"
echo 'TEST_TEMP_DIR= '$TEST_TEMP_DIR
mkdir -p $TEST_TEMP_DIR

#  --entrypoint="consul-template"
cd "${DOCKERFILE_DIR}" && make -B

cd "${TEST_DIR}"

docker run --rm -ti  \
 --name revproxy1 \
 --net=host \
 -v "${TEST_DIR}/etc:/etc:rw" \
 -v "${TEST_DIR}/conf-nginx:/conf-nginx:rw" \
 -v "${TEST_TEMP_DIR}:/tmp:rw" \
 --entrypoint="supervisord" \
fvigotti/webserver-nginx-consultpl -n -c /etc2/supervisord/init.conf

echo "open : http://127.0.0.1:80/python-micro-service/"


#docker run --rm -ti  --entrypoint="consul-template" fvigotti/webserver-nginx-consultpl:latest \
#  -v "etc:/etc:ro" \
#  -consul=10.0.11.22:8500 -template "/etc/consul-templates/sample1.tpl:/tmp/result:service nginx restart" -dry
#&& docker run --rm -ti  --entrypoint="consul-template" fvigotti/webserver-nginx-consultpl:0.1  -consul=10.0.11.22:8500 -template "/etc/consul-templates/sample1.tpl:/tmp/result:service nginx restart" -dry