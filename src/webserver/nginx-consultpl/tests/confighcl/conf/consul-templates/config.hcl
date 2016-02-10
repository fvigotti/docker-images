// consul template configuration file , HCL ref: https://github.com/hashicorp/hcl
// https://github.com/hashicorp/consul-template

consul = "consul:8500" // this works if consul is binded to shared-host-consulAgent : --add-host="consul:172.17.0.1"
retry = "10s"
max_stale = "10m"
log_level = "info"


template {
  source = "/etc2/consul-templates/sample1.tpl"
  destination = "/conf-nginx/nginx.conf"
  command = "echo 'template updated!'"
//  command_timeout = "60s"
  perms = 0600
  backup = true
}


template {
  source = "/etc2/consul-templates/test.tpl"
  destination = "/test.conf"
  command = "echo 'template updated!'"
  perms = 0777
  backup = true
}

