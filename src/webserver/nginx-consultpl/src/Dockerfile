FROM fvigotti/webserver-nginx-php


######## ---- INSTALL CONSUL

#ENV DL_URL https://releases.hashicorp.com/consul-template/0.12.2/consul-template_0.12.2_linux_amd64.zip
#RUN curl -sSL $DL_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

ARG version=0.12.2

ENV VERSION $version

RUN git clone https://github.com/hashicorp/consul-template.git /go/src/github.com/hashicorp/consul-template

WORKDIR /go/src/github.com/hashicorp/consul-template

RUN git reset --hard v$VERSION

# Fails without being piped to true
RUN make updatedeps || /bin/true
RUN make dev


ADD etc /etc
ENTRYPOINT supervisord -n