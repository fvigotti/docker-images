FROM fvigotti/webserver-nginx-supervisor
RUN apt-get update && \
	apt-get install -y php5-cli php5-curl php5-fpm php5-gd php5-mcrypt php5-mysql php5-pgsql php5-sqlite && \
	apt-get clean && \
	echo -n > /var/lib/apt/extended_states
RUN rm -rf /etc/nginx/addon.d /etc/php5/fpm/pool.d && \
	mkdir -p /etc/nginx/addon.d /etc/php5/fpm/pool.d
ADD etc /etc
