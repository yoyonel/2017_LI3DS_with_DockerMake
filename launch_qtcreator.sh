#!/bin/bash

xhost +

if [ ! -d li3ds/.volumes/dev/qtcreator/.config ]; then
	mkdir -p li3ds/.volumes/dev/qtcreator/.config
fi

# -e NEWUSER=$USER \
docker run 	-it --rm 															\
			--name qtcreator 													\
			-h qtcreator 														\
            -e DISPLAY=$DISPLAY 												\
            -v /tmp/.X11-unix:/tmp/.X11-unix 									\
            --security-opt seccomp=unconfined 									\
            -v $(realpath li3ds/.volumes/dev/qtcreator/.config):/home/.config 	\
            --volumes-from li3ds_ros 											\
            li3ds-dev_qtcreator $@