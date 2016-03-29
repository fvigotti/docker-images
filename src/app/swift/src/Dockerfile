  FROM fvigotti/env-fatubuntu

RUN apt-get install libffi-dev
RUN pip install --upgrade pip && \
    pip install  python-swiftclient python-keystoneclient && \
    pip install requests[security]

ADD s_.sh /usr/bin/s_
ADD safeDelete_.sh /usr/bin/safeDelete_
RUN chmod +x /usr/bin/s_ /usr/bin/safeDelete_
# pip install  libffi-dev libssl-dev     pyopenssl ndg-httpsclient pyasn1  && \
