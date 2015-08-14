FROM fvigotti/webserver-nginx-php

ENV PHPMYADMIN_VERSION 4.4.13.1

RUN whoami

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 \
 && tar -xvjf /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 -C / \
 && rm /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2  \
 && rsync -a /phpMyAdmin-${PHPMYADMIN_VERSION}-english/ /data/http/

# && mv /phpMyAdmin-${PHPMYADMIN_VERSION}-english /var/pma/ && ls -laR /var/pma/
# && rm -r /data/http \

RUN  ls -laR /data/http/
# add phpmyadmin setup file
ADD config/* /config/
ADD data/* /data/
ADD data/* /data/http/
RUN  ls -laR /data/

