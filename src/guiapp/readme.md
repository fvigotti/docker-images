## application with gui dockerized : 

## PRE : 
 - configure Xauthority
 
 
sample usage:
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix fvigotti/guiapp-firefox

