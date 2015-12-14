## application with gui dockerized : 

## PRE : 
 - configure Xauthority
 
 
##sample usage:
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix fvigotti/guiapp-firefox



## MORE:
https://blog.jessfraz.com/post/docker-containers-on-the-desktop/
-- toread:
https://blog.docker.com/2013/07/docker-desktop-your-desktop-over-ssh-running-inside-of-a-docker-container/
http://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container
http://stackoverflow.com/questions/32151043/xvfb-docker-cannot-open-display
https://hub.docker.com/r/selenium/standalone-firefox/
https://github.com/SeleniumHQ/docker-selenium




## under tests:
docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --name cathode jess/1995




