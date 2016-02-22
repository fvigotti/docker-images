
docker run -ti --rm --net=host --entrypoint="/opt/logstash/bin/logstash" logstash:latest  -e 'input { stdin { } } output { elasticsearch { hosts => ["localhost"] } }'

## show elasticsearch stored data:
http://localhost:9200/_search?pretty

## view kibana:
http://localhost:5601/app/kibana
--- nb: before creating index pattern ensure that `Time-field name` contain `@timestamp`