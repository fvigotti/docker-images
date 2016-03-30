FROM fvigotti/env-fatubuntu

RUN apt update && apt -y --quiet upgrade
RUN apt-get -y --quiet install python-dev libmysqlclient-dev  python-mysqldb
RUN pip install --upgrade pip
RUN pip install MySQL-python
