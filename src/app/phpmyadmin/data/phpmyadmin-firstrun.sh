#!/bin/bash

sed -i.bak 's|$PMA_USERNAME|'"$PMA_USERNAME"'|g' /create_user.sql
sed -i.bak 's|$PMA_PASSWORD|'"$PMA_PASSWORD"'|g' /create_user.sql

mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT --user=$MYSQL_USERNAME --password=$MYSQL_PASSWORD < /www/sql/create_tables.sql
mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT --user=$MYSQL_USERNAME --password=$MYSQL_PASSWORD < /create_user.sql

rm /usr/local/bin/phpmyadmin-firstrun