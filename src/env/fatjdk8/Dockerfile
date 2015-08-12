FROM fvigotti/env-fatubuntu

RUN cd /usr/local/src && \
    git clone https://github.com/fvigotti/bash-ubuntu-oraclejdk && \
    chmod +x /usr/local/src/bash-ubuntu-oraclejdk/src/install_oracle_jdk.sh && \
    chmod +x /usr/local/src/bash-ubuntu-oraclejdk/src/install_groovy.sh && \
    /bin/bash /usr/local/src/bash-ubuntu-oraclejdk/src/install_oracle_jdk.sh && \
    /bin/bash /usr/local/src/bash-ubuntu-oraclejdk/src/install_groovy.sh


ENV SCALA_VERSION 2.11.6
ENV SBT_VERSION 0.13.8

# Install Scala
RUN \
  cd /root && \
  curl -o scala-$SCALA_VERSION.tgz http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
  tar -xf scala-$SCALA_VERSION.tgz && \
  rm scala-$SCALA_VERSION.tgz && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt

# Define working directory
WORKDIR /root



#ENTRYPOINT ["java", "-jar", "/whatever/your.jar"]

