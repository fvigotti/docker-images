FROM fvigotti/env-fatubuntu

env STABLE_WHISPER_BRANCH 0.9.13

# install whisper
RUN git clone -b ${STABLE_WHISPER_BRANCH} https://github.com/graphite-project/whisper.git /opt/whisper_stable
RUN git clone https://github.com/graphite-project/whisper.git /opt/whisper_live

VOLUME /opt/whisper_live
VOLUME /opt/whisper_stable

