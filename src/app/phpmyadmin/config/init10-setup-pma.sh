#!/bin/bash

if [ ! -z "$DEBUG" ]; then
    set -x
fi

echo ' performing setup of phpmyadmin if necessary'
export PMA_DBNAME=${PMA_DBNAME:-phpmyadmin}
export PMA_GRANT_USER_FILEPATH="/data/grant_user.sql"
export PMA_BASEPATH="/data/http/"
export PMA_INITIALIZE_DB_FILEPATH="${PMA_BASEPATH}/sql/create_tables.sql"

function myecho {
    if [ ! -z "$DEBUG" ]; then
        echo "$*"
    fi
}

function myecho_read {
    if [ ! -z "$DEBUG" ]; then
        while read data; do
          echo "$data"
        done
    fi
}

# wait for mysql to start using tcp ( mysqladmin )
wait_for_mysql_to_start_useTcp() {
    USER=$1
    PASS=$2
    TIMEOUT_SECONDS=${3:-10}
    echo 'wait_for_mysql_to_start , TIMEOUT='${TIMEOUT_SECONDS}
    let loopTimeOut=$(date +%s)+${TIMEOUT_SECONDS}
    export wait_mysql_up_status="0";
    #mysqladmin -u root -p status

    # Wait for mysql to finish starting up first.
    while [[ "x${wait_mysql_up_status}x" = "x0x" ]] ; do
      sleep 1
      myecho '[WAITING_MYSQL]'mysqladmin -u${USER} -p${PASS} --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT ping
      /usr/bin/mysqladmin -u${USER} -p${PASS} --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT ping > /dev/null 2>&1 && export wait_mysql_up_status=1 || export wait_mysql_up_status=0
#      echo "results : " $(/usr/bin/mysqladmin -u${USER} -p${PASS} --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT ping)
      if [ $(date +%s) -gt $loopTimeOut ]; then
       echo "wait_for_mysql_to_start has timed out "
       exit 1
      fi
    done
    echo "mysql started"
    return 0
}

test_db_action(){
USER=$1
PASS=$2
ACTION=$3
#echo "test_db_action cur action value = $ACTION"
MYSQL="mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT  -u$USER -p${PASS} -e"
#mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT  -u$USER -p${PASS} $ACTION 1>/dev/null 2>&1 ; [[ $? -eq 0 ]] && {
eval $MYSQL "'$ACTION'" 1>/dev/null 2>&1 ; [[ $? -eq 0 ]] && {
    echo '[test_db_action] VALID!'  >&2
    myecho '[test_db_action] -u'$USER' -p'${PASS}' db: '${DBNAME}' , action ('${ACTION}') VALID!'
    return 0; # return true
    } || {
    echo '[test_db_action] NOT valid !'  >&2
    myecho '[test_db_action] 'mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT  -u$USER -p${PASS} ${ACTION}
    return 1; # return false
    }
}

test_user_and_pass(){
USER=$1
PASS=$2
ACTION=" "
#ACTION=" -e \"\" "
echo "cur action value = $ACTION"
test_db_action $USER $PASS "$ACTION"
}

test_db(){
USER=$1
PASS=$2
DBNAME=$3
ACTION="SHOW TABLES FROM ${DBNAME}"
test_db_action $USER $PASS "$ACTION"
}
import_db_dump(){
USER=$1
PASS=$2
DUMPFILE_PATH=$3
ACTION="< $DUMPFILE_PATH"
## test_db_action $USER $PASS "$ACTION" crazy error that replace the $action param quoting the minor symbol!  '<' /data/http//sql/create_tables.sql
mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT  -u$USER -p${PASS} < $DUMPFILE_PATH 1>/dev/null 2>&1 ; [[ $? -eq 0 ]] && {
    echo '[import_db_dump] VALID!'  >&2
    return 0; # return true
    } || {
    echo '[import_db_dump] NOT valid !'  >&2
    return 1; # return false
    }
}

export CONFIGURED_ADMIN_CREDENTIALS=false
echo "checking provided user credentials ..."
if [ ! -z $MYSQL_USERNAME ] && [ ! -z $MYSQL_PASSWORD ]; then
    myecho 'CONFIGURED_ADMIN_CREDENTIALS :  user = '${MYSQL_USERNAME}' pass = '${MYSQL_PASSWORD}
    export CONFIGURED_ADMIN_CREDENTIALS=true
    #if test_user_and_pass $MYSQL_USERNAME $MYSQL_PASSWORD ; then
    #   export CONFIGURED_ADMIN_CREDENTIALS=true
    #fi
fi

echo 'CONFIGURED_ADMIN_CREDENTIALS = '${CONFIGURED_ADMIN_CREDENTIALS}

# mysql container could been started together with PMA, wait for mysql to be up..
if [ $CONFIGURED_ADMIN_CREDENTIALS = "true" ];  then
    wait_for_mysql_to_start_useTcp $MYSQL_USERNAME $MYSQL_PASSWORD 60
else
    wait_for_mysql_to_start_useTcp $PMA_USERNAME $PMA_PASSWORD 60
fi




# SETUP CONFIGURATION CHECK
if [ "${CONFIGURED_ADMIN_CREDENTIALS}" = true ]; then


    if ! test_db $MYSQL_USERNAME $MYSQL_PASSWORD  $PMA_DBNAME ; then
        myecho '[test_db] opening pma database with admin credentials  '$MYSQL_USERNAME' '${PMA_PASSWORD}' has failed!'

        if import_db_dump  $MYSQL_USERNAME $MYSQL_PASSWORD $PMA_INITIALIZE_DB_FILEPATH; then
            echo "SUCCESS! DATABASE FOR PMA INITIALIZED!"
        else
            myecho 'ERROR IMPORTING DATABASE DUMP' $MYSQL_USERNAME $MYSQL_PASSWORD $PMA_INITIALIZE_DB_FILEPATH
            echo "FATAL ERROR! INITIALIZATION OF PMA DATABASE FAILED!"
            exit 1
        fi
    fi # end PMA database initialization

    if ! test_user_and_pass $PMA_USERNAME $PMA_PASSWORD ; then
        echo "admin mode on, creating PMA Account"

        echo 'updating '$PMA_GRANT_USER_FILEPATH' file'
        sed -i 's|$PMA_USERNAME|'"$PMA_USERNAME"'|g' $PMA_GRANT_USER_FILEPATH
        sed -i 's|$PMA_PASSWORD|'"$PMA_PASSWORD"'|g' $PMA_GRANT_USER_FILEPATH

        echo ".. applying grant user file to database using administration credentials"
        if import_db_dump $MYSQL_USERNAME $MYSQL_PASSWORD $PMA_GRANT_USER_FILEPATH; then
            echo "SUCCESS! CREDENTIALS FOR PMA CREATED!"
        else
            myecho "error importing database dump "$MYSQL_USERNAME" "$MYSQL_PASSWORD" "$PMA_GRANT_USER_FILEPATH
            echo "FATAL ERROR! CREDENTIALS FOR PMA CREATION FAILED !"
            exit 1
        fi

    fi # end PMA credentials initialization

fi

if test_user_and_pass $PMA_USERNAME $PMA_PASSWORD ; then
    echo 'db credentials are ok!'
    if test_db $PMA_USERNAME $PMA_PASSWORD $PMA_DBNAME ; then
        echo 'PMA DATABASE ( '${PMA_DBNAME}' exists and is readable by pma credentials'
    else
        echo "PMA database is not readable by pma credentials or does not exists! "
        exit 2
    fi
else
    echo "[FATAL] PMA credentials are not valid "
    exit 3
fi


cp /data/config.inc.php $PMA_BASEPATH

sed -i \
    -e "s|\$PMA_SECRET|$PMA_SECRET|g" \
    -e "s|\$PMA_USERNAME|$PMA_USERNAME|g" \
    -e "s|\$PMA_PASSWORD|$PMA_PASSWORD|g" \
    -e "s|\$PMA_URI|$PMA_URI|g" \
    -e "s|\$MYSQL_PORT_3306_TCP_ADDR|$MYSQL_PORT_3306_TCP_ADDR|g" \
    -e "s|\$MYSQL_PORT_3306_TCP_PORT|$MYSQL_PORT_3306_TCP_PORT|g" \
    $PMA_BASEPATH/config.inc.php
