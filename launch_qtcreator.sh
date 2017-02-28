#!/bin/bash

xhost +

# -e NEWUSER=$USER \
docker run 	-it --rm \
			--name qtcreator \
			-h qtcreator \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $(realpath li3ds/.volumes/dev/qtcreator/.config):/home/.config \
            --security-opt seccomp=unconfined \
            --volumes-from li3ds_ros \
            li3ds-dev_qtcreator $@