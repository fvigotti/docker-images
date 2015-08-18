#!/bin/bash
set -xe
export ROOT_PATH_DISTANCE='../'
export TEST_CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo 'TEST_CURRENT_DIR = '$TEST_CURRENT_DIR

export PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")" && cd ${ROOT_PATH_DISTANCE} && pwd )
echo 'PROJECT_ROOT = '$PROJECT_ROOT

rebuild_env(){
docker rmi -f fvigotti/env-fatubuntu || echo error ignored
docker rmi -f fvigotti/env-fatubuntu-supervisord  || echo error ignored
docker rmi -f fvigotti/env-fatubuntu-bashsupervisor  || echo error ignored
docker rmi -f fvigotti/env-jdk  || echo error ignored

docker build -t "fvigotti/env-fatubuntu" $PROJECT_ROOT/src/env/fatubuntu
docker build -t "fvigotti/env-fatubuntu-supervisord" $PROJECT_ROOT/src/env/fatubuntu-supervisord
docker build -t "fvigotti/env-fatubuntu-bashsupervisor" $PROJECT_ROOT/src/env/fatubuntu-bashsupervisor
docker build -t "fvigotti/env-jdk" $PROJECT_ROOT/src/env/jdk
}

rebuild_webserver(){
docker rmi -f fvigotti/webserver-nginx  || echo error ignored
docker rmi -f fvigotti/webserver-nginx-supervisor  || echo error ignored
docker rmi -f fvigotti/webserver-nginx-php  || echo error ignored

docker build -t "fvigotti/webserver-nginx" $PROJECT_ROOT/src/webserver/nginx
docker build -t "fvigotti/webserver-nginx-supervisor" $PROJECT_ROOT/src/webserver/nginx-supervisor
docker build -t "fvigotti/webserver-nginx-php" $PROJECT_ROOT/src/webserver/nginx-php
}

rebuild_db(){
docker rmi -f fvigotti/db-mariadb  || echo error ignored

docker build -t "fvigotti/db-mariadb" $PROJECT_ROOT/src/db/mariadb
}

rebuild_app(){
docker rmi -f fvigotti/app-phpmyadmin  || echo error ignored

docker build -t "fvigotti/app-phpmyadmin" $PROJECT_ROOT/src/app/phpmyadmin
}

#rebuild_env
rebuild_webserver
rebuild_db
rebuild_app

#
#docker build -t "fvigotti/env-fatubuntu" $PROJECT_ROOT/src/env/fatubuntu
#docker build -t "fvigotti/env-fatubuntu-supervisord" $PROJECT_ROOT/src/env/fatubuntu-supervisord
#docker build -t "fvigotti/env-fatubuntu-bashsupervisor" $PROJECT_ROOT/src/env/fatubuntu-bashsupervisor




