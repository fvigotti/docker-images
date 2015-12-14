## application with gui dockerized : 

## PRE : 
 - configure Xauthority
 
 
##sample usage:
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix fvigotti/guiapp-firefox



## MORE:
https://blog.jessfraz.com/post/docker-containers-on-the-desktop/




## under tests:
docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --name cathode jess/1995




