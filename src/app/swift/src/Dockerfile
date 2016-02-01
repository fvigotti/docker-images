FROM fvigotti/env-fatubuntu

RUN apt-get install libffi-dev
RUN pip install --upgrade pip && \
    pip install  python-swiftclient python-keystoneclient && \
    pip install requests[security]
# pip install  libffi-dev libssl-dev     pyopenssl ndg-httpsclient pyasn1  && \
