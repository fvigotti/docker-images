# fvigotti/env-fatubuntu-bashsupervisor 
* based on fvigotti/env-fatubuntu image
 
docker ubuntu images which execute init scripts  

this Docker image start from ubuntu:14.04 and a startup which:  
- executes ordered /config/init* files  
- forward signals to them when receive ones  

the default CMD is also the main script , should be overridden only for debug purposes   
` CMD /config/starter.sh `  

# env vars:
- `--env "DEBUG=1"` if passed output of the supervisor is more verbose  

### DEBUG:  
`docker run --rm -ti fvigotti/env-fatubuntu-bashsupervisor /bin/bash`


## default usage
image should be inherited adding additional `init**.sh` scripts to `/config`  
the last script should execute the real application or supervisord
