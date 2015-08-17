FROM fvigotti/webserver-nginx-php

ENV PHPMYADMIN_VERSION 4.4.13.1

RUN whoami


RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 \
 && tar -xvjf /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 -C / \
 && rm /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2  \
 && rsync -a /phpMyAdmin-${PHPMYADMIN_VERSION}-english/ /data/http/

RUN  ls -laR /data/http/
RUN  ls -laR /data/

# add phpmyadmin setup file
ADD config/* /config/
ADD data/* /data/

RUN  ls -laR /data/
