FROM fvigotti/env-fatubuntu

# default shell must be bash ( TRAP doesn't seems to work correctly on dash )
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#base dir
RUN mkdir -p /config /data

ADD config /config

RUN chmod -R +x /config

# default command
CMD /config/starter.sh