FROM fvigotti/webserver-nginx-supervisor

RUN apt-get update && \
    apt-get install -y \
                         libxml2-dev \
                         libcurl4-openssl-dev \
                         libjpeg-dev \
                         libpng-dev \
                         libxpm-dev \
                         libmysqlclient-dev \
                         libpq-dev \
                         libicu-dev \
                         libfreetype6-dev

ENV PHP_VERSION php-5.6.16

WORKDIR /usr/local/src/
RUN wget -O ${PHP_VERSION}.tar.gz http://dk2.php.net/get/${PHP_VERSION}.tar.gz/from/this/mirror && \
 tar -zxvf ${PHP_VERSION}.tar.gz && \
 cd ${PHP_VERSION} && \
 ./configure \
   --prefix=/usr/local/php \
   --enable-mbstring \
   --enable-fpm \
   --with-curl \
   --with-openssl \
   --with-xmlrpc \
   --enable-soap \
   --enable-zip \
   --with-gd \
   --with-jpeg-dir \
   --with-png-dir \
   --with-mysql \
   --with-pgsql \
   --enable-embedded-mysqli \
   --with-freetype-dir \
   --enable-intl \
   --with-xsl && \
   make &&  make install
# make test &&


RUN rm -rf /etc/nginx/addon.d /etc/php5/fpm/pool.d && \
	mkdir -p /etc/nginx/addon.d /etc/php5/fpm/pool.d
ADD etc /etc
