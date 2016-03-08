
# jolokia standalone agent/proxy

entrypoint & version check : `http://localhost:8080/jolokia`

## accept proxy requests ie:
`curl -H "Content-Type: application/json" --data @/tmp/jj http://localhost:8080/jolokia/`

where /tmp/jj contain : 
```json
{
    "type":"READ"
    "mbean":"java.lang:type=Threading",
    "attribute":"ThreadCount",
    "target": { 
                "url":"service:jmx:rmi:///jndi/rmi://$HOST:$HOSTJMXPORT/jmxrmi",
                "password":"admin",
                "user":"s!cr!t"
              },
  }
```
