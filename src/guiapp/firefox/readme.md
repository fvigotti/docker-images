#build 
docker build -t firefox .



# run
## pre run : `xhost +` ( allow access to terminal from everywhere ) 

## anyway still to test everything, none of those works ( but it worked once, have to re-find the solution ) 
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix firefox
docker run -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix  --net=host  firefox
docker run --rm -e DISPLAY -v $HOME/.Xauthority:/home/developer/.Xauthority --net=host firefox


## after run : `xhost -` ( disable access again, anyway acl should be set for that)

