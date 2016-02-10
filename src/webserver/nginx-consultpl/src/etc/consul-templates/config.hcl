// consul template configuration file , HCL ref: https://github.com/hashicorp/hcl

template {
  source = "/etc/consul-templates/sample1.tpl"
  destination = "/tmp/sample1.conf"
  command = "echo 'template updated!'"
  //command_timeout = "60s"
  perms = 0600
  backup = true
}

