FROM fvigotti/env-fatubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN npm install -g bower  && \
 npm install --global gulp

VOLUME  ["/opt/build"]
VOLUME  ["/opt/target"]
VOLUME  ["/opt/scripts"]


WORKDIR /opt/scripts

ENTRYPOINT ["/bin/bash"]
