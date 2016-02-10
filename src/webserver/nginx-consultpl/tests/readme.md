# confighcl 
 - test consul configuration hcl file
 
 
## subcommands:
- consul template: 
```
consul-template -config /etc2/consul-templates/config.hcl -dry
```

- playing with templates : 
```
watch -n 1 "clear && consul-template -config /etc2/consul-templates/config.hcl --conce && cat /test.conf"

```