upstream python-service {
least_conn;
{{range service "python-micro-service"}}server {{.Address}}:{{.Port}} max_fails=3 fail_timeout=60 weight=1;
{{else}}server 127.0.0.1:65535; # force a 502{{end}}
}

MaxWorkers {{key "web/max-workers"}}
JobsPerSecond {{key "web/jobs-per-second"}}

{{range service "python-micro-service"}}
{{/* if .Tags | contains "localhost" */}}
{{/*  if in .Tags "localhost" */}}
{{/*  if in .ServiceName "python-micro-service" */}}
{{/*if .Name eq "python-micro-service"*/}}
upstream {{.Name}} {
least_conn;
{{range service .Name}}
server  {{.Address}}:{{.Port}} max_fails=3 fail_timeout=60 weight=1;
{{end}}
}
{{end}}
