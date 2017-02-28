#!/bin/bash

xhost +

docker run 	-it --rm \
			--name qtcreator \
			-h qtcreator \
			-e NEWUSER=$USER \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $(realpath li3ds/.volumes/dev/qtcreator/.config):/home/.config \
            --security-opt seccomp=unconfined \
            li3ds-dev_qtcreator $@