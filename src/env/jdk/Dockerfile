FROM fvigotti/env-fatubuntu

RUN mkdir -p /scripts/
ADD scripts /scripts/

RUN cd /usr/local/src && \
    chmod +x /scripts/* && \
    /bin/bash /scripts/install_oracle_jdk.sh && \
    /bin/bash /scripts/install_groovy.sh


# Define working directory
WORKDIR /root


#ENTRYPOINT ["java", "-jar", "/whatever/your.jar"]

