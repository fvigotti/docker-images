FROM fvigotti/env-fatubuntu


RUN curl http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add - && \
    echo "deb http://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list && \
    sudo apt-get update && sudo apt-get -y install filebeat

ENTRYPOINT ["/usr/bin/filebeat"]
CMD ["-e" ,"-c" , "/etc/filebeat/filebeat.yml"]


