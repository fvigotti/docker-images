
# entry points : 
## inherited from bash  supervisor
all bash script found in /config will be executed 

# updating:
- update version in dockerfile
- new config.inc.php can be found here : `https://github.com/phpmyadmin/phpmyadmin/blob/master/libraries/config.default.php`

# required envs:
- MYSQL_USERNAME
- MYSQL_PASSWORD
- PMA_USERNAME
- PMA_PASSWORD
- PMA_SECRET

# optional envs:
- PMA_AUTHTYPE : **cookie**(default) or config, http, signon
- DEBUG : if set, will enable move verbose output ( also with passwords ) 
- MYSQL_PORT_3306_TCP_ADDR="127.0.0.1"  
- MYSQL_PORT_3306_TCP_PORT="3306"  
 
# not yet implemented correctly:
- PMA_DBNAME 
 
# defaults:
- mysql links: if mysql address is not provided will default to **mysql** linked container   
 
# debug mode:
providing the following **env var** the debug mode is activated , output is more verbose but also db passwords will be printed out!   


  
# mysql linking:
mysql is passed by linking a container using `mysql` as alias, or providing required **env vars** ie:  


# admin modes:  
the application could run in admin mode:  

 - automatic creation of phpmyadmin database  
 - automatic creation of PMA credentials  

to run in admin mode provide the following **env vars** :   

- $MYSQL_USERNAME     
- $MYSQL_PASSWORD     

# PMA configuration:
 
 - $PMA_SECRET 
 - $PMA_USERNAME 
 - $PMA_PASSWORD 

## NB: PMA credentials are replaced in config files during bootstrap PHASE
if file /data/config.inc.php is externally provided, add the **env var**

- $PMA_CONFIG_AUTO=off


#sample uasge:
docker run --name phpmyadmin-mysql -e MYSQL_ROOT_PASSWORD=password -ti --rm mariadb
docker run -ti --rm --link phpmyadmin-mysql:mysql -e MYSQL_USERNAME=root -e MYSQL_PASSWORD=password -e DEBUG=1 -e PMA_USERNAME=a -e PMA_PASSWORD=b -e PMA_SECRET=aaaa --name phpmyadmin -p 2000:80 fvigotti/app-phpmyadmin

