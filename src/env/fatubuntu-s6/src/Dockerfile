FROM fvigotti/env-fatubuntu
RUN mkdir /tmp/skalibs && curl -sSL https://github.com/skarnet/skalibs/archive/v2.3.9.0.tar.gz | tar xvfz - -C /tmp/skalibs
RUN cd /tmp/skalibs/skalibs* && ./configure && make && make install

RUN mkdir /tmp/s6 && curl -sSL https://github.com/skarnet/s6/archive/v2.2.4.3.tar.gz | tar xvfz - -C /tmp/s6
RUN cd /tmp/s6/s6*
RUN cd /tmp/skalibs/skalibs* && ./configure && make && make install

