

# env:
- $MYSQL_PORT_3306_TCP_ADDR
- $MYSQL_PORT_3306_TCP_PORT
- DEBUG=false 
-- 
ENV PMA_SECRET          blowfish_secret
ENV PMA_USERNAME        pma
ENV PMA_PASSWORD        password
ENV MYSQL_USERNAME      mysql
ENV MYSQL_PASSWORD      password
ENV MAX_UPLOAD "50M"

  DEBUG