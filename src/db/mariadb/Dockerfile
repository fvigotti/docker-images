FROM fvigotti/env-fatubuntu

RUN apt-get install software-properties-common && \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
  add-apt-repository 'deb ftp://ftp.ulak.net.tr/pub/MariaDB/repo/10.0/ubuntu trusty main' && \
  apt-get -y --quiet update  && \
  apt-get -y --quiet install mariadb-server





ENV DATA_DIR /data
ENV FIRST_RUN_DUMP_DIR /first_run_dumps


ADD scripts /scripts

RUN chmod +x /scripts/supervisor.sh && \
    touch /firstrun && \
    mkdir -p ${FIRST_RUN_DUMP_DIR}



# Configure the database to use our data dir.
# && Configure MariaDB to listen on any address.
# &&
# Change the innodb-buffer-pool-size to 128M (default is 256M).
# This should make it friendlier to run on low memory servers.

#RUN sed -i -e 's/^datadir\s*=.*/datadir = \'${DATA_DIR}'/' /etc/mysql/my.cnf && \
#    sed -i -e 's/^bind-address/#bind-address/' /etc/mysql/my.cnf && \
#    sed -i -e 's/^innodb_buffer_pool_size\s*=.*/innodb_buffer_pool_size = 128M/' /etc/mysql/my.cnf

RUN rm /etc/mysql/my.cnf
ADD /etc/mysql/my.cnf /etc/mysql/my.cnf
RUN chmod 644 /etc/mysql/my.cnf

EXPOSE 3306

# Expose our data, log, and configuration directories.
VOLUME ["${DATA_DIR}", "/var/log/mysql", "/etc/mysql"]

# Expose ports.
EXPOSE 3306

CMD ["/bin/bash" , "/scripts/supervisor.sh"]