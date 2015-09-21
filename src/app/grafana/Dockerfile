FROM fvigotti/env-fatubuntu

ENV GRAFANA_VERSION 2.1.3_amd64

RUN mkdir /grafana && \
    wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}.deb -O /grafana/grafana.deb && \
    dpkg -i /grafana/grafana.deb


EXPOSE 3000

#grafana workdir is necessary in current beta ( bug in grafana return : [setting.go:280 initLogging()] [E] Unknown log mode: console )
WORKDIR /opt/grafana/current

ENTRYPOINT ["/opt/grafana/current/grafana"]
CMD ["--config=/etc/grafana/grafana.ini", "web"]


