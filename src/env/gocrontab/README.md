# fvigotti/env-gocrontab 
* based on fvigotti/env-fatubuntu image
* ispiration taken from : https://github.com/webwurst/docker-go-cron
 

See:
- https://github.com/odise/go-cron
- https://github.com/rk/go-cron

Example:
```bash
$ docker run -e SCHEDULE="@every 10s" -e COMMAND="echo hello" fvigotti/env-gocrontab


# or override bash script execution 
$ docker run fvigotti/env-gocrontab go-cron -s "@every 5s" -- /bin/bash -c "chmod +x /app/app1.sh && exec /app/app1.sh"


```