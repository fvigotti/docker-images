#!/bin/sh

if [ -f "/usr/local/bin/phpmyadmin-firstrun" ];
then
	/usr/local/bin/phpmyadmin-firstrun
fi

cp /config.inc.php /www

sed -i \
    -e "s|\$PMA_SECRET|$PMA_SECRET|g" \
    -e "s|\$PMA_USERNAME|$PMA_USERNAME|g" \
    -e "s|\$PMA_PASSWORD|$PMA_PASSWORD|g" \
    -e "s|\$PMA_URI|$PMA_URI|g" \
    -e "s|\$MYSQL_PORT_3306_TCP_ADDR|$MYSQL_PORT_3306_TCP_ADDR|g" \
    -e "s|\$MYSQL_PORT_3306_TCP_PORT|$MYSQL_PORT_3306_TCP_PORT|g" \
    /www/config.inc.php

service php5-fpm start

exec nginx -g "daemon off;"