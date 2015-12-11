FROM fvigotti/env-fatubuntu

# NGINX CHANGELOGS : http://nginx.org/en/CHANGES

##################
# NB: provided version will be installed, not latest one!
##################

################ THIS VERSION WILL BE INSTALLED
#ENV NGINX_VERSION 1.9.5-1~trusty
ENV NGINX_VERSION "1.9.9-1~trusty"
################ JUST TO KNOW..., CHECK WHAT IS LATEST VESION AVAILABLE
#RUN export NGINX_LATEST_AVAILABLE_VERSION="$(curl --silent "http://nginx.org/packages/mainline/ubuntu/dists/trusty/nginx/binary-amd64/Packages" |  grep -A 1 -e 'Package: nginx$' | grep -e  '^Version:' | sed 's/^Version: //')"


RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" >> /etc/apt/sources.list


RUN echo "NGINX_VERSION=${NGINX_VERSION}" && apt-get update && apt-get upgrade -y  && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# delete conf.d/default.conf && prepare base dirs structure
RUN rm -rf /etc/nginx/*.d && \
	mkdir -p /etc/nginx/addon.d /etc/nginx/conf.d /etc/nginx/host.d /etc/nginx/nginx.d && \
	mkdir -p /data/http/ /data/logs/ /data/config/

# add /etc/nginx configuration, but do not overwrite existing default nginx configuration (Exception for /etc/nginx/nginx.conf )
ADD etc /etc

#VOLUME ["/etc/nginx"]

# datafiles in : /data/http/
# logs in : /data/logs/
# plugin conf in : /data/config/nginx-*.conf
#VOLUME ["/data"]

#VOLUME ["/var/cache/nginx"]
#VOLUME ["/var/log/nginx/"]

# EXPOSE 80 443

ENTRYPOINT ["nginx"]
# CMD ["-g", "daemon off;"]
