
# docker multi image repository

- automated build are placed in `fvigotti` docker hub registry,  
    image naming is `fvigotti/$parentName-$name` ie: 
    - `fvigotti/webserver-nginx` 
    - `fvigotti/webserver-nginx-php`
     
     
     
# TESTS
- ## nginx
    - `tests/webserver/nginx/test.sh`  
        start webserver with default configuration and curl some test files

# credits and inspirations:
- https://github.com/maxexcloo/Docker
