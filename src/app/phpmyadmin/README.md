

# debug:
providing the following **env var** the debug mode is activated , output is more verbose but also db passwords will be printed out!   

 - $DEBUG=true
  
# mysql linking:
mysql is passed by linking a container using `mysql` as alias, or providing required **env vars** :  

 - $MYSQL_PORT_3306_TCP_ADDR="127.0.0.1"  
 - $MYSQL_PORT_3306_TCP_PORT="3306"  

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

