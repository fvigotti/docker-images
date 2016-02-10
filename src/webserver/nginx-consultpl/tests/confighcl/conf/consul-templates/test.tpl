# current node : {{node}}
# current node node : {{with node}}{{.Node.Node}}{{end}}
# nodes : {{nodes}}

## reange service :
{{range service "python-micro-service"}}
server {{.Node}} address : {{.Address}} port:{{.Port}}//end{{end}}

rangebytag:
{{range $tag, $serviceVal := service "python-micro-service" | byTag}}{{$tag}}
serviceVal = {{ $serviceVal }} {{range $serviceVal}} server {{.Name}} {{.Address}}:{{.Port}}
{{end}}{{end}}

{{service "python-micro-service"}}
{{.Node.Address}}
{{range service "python-micro-service"}}
server {{.Name}} {{.Address}}:{{.Port}}{{end}}
aa

