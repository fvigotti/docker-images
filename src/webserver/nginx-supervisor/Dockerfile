FROM fvigotti/webserver-nginx
RUN apt-get update && \
	apt-get install -y supervisor && \
	apt-get clean && \
	echo -n > /var/lib/apt/extended_states

ADD etc /etc
ADD config /config

RUN chmod +x /config/loop

ENTRYPOINT []

CMD /config/loop
