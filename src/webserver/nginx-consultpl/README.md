# configurations:
https://github.com/h5bp/server-configs-nginx/blob/master/nginx.conf#L101

# compile:
`make build`
 
## go template help:
 - https://gohugo.io/templates/go-templates/
 - https://gowalker.org/github.com/hashicorp/consul-template
  
  
# running:

## test
make -B && \
docker run --rm -ti  --entrypoint="consul-template" fvigotti/webserver-nginx-consultpl:0.1  -consul=10.0.11.22:8500 -template "/etc/consul-templates/sample1.tpl:/tmp/result:service nginx restart" -dry
-- explore consul cluster  
`
curl http://10.0.11.21:8500/v1/catalog/services | jq .
curl http://10.0.11.21:8500/v1/catalog/service/python-micro-service | jq .
` 