daemon off;

worker_rlimit_nofile    600;
pid /nginx.pid;
worker_processes  6;

events {
worker_connections  1024;  ## Default: 1024
}

http {

error_log /dev/stdout info;
access_log /dev/stdout;


#Address
upstream python-service{
least_conn;
{{range service "python-micro-service"}}
server {{.Address}}:{{.Port}} max_fails=3 fail_timeout=60 weight=1;
{{else}}server 127.0.0.1:65535; # force a 502{{end}}
}

#MaxWorkers {{key_or_default "web/max-workers" "5"}}
#JobsPerSecond {{key_or_default "web/jobs-per-second" "100"}}


server {
listen 80 default_server;

charset utf-8;

location ~ ^/python-micro-service/(.*)$ {
proxy_pass http://python-service/$1$is_args$args;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
}
}

}