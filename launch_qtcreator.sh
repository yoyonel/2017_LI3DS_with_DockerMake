#!/bin/bash

xhost +

if [ ! -d project/.volumes/dev/qtcreator/.config ]; then
	mkdir -p project/.volumes/dev/qtcreator/.config
fi

# -v $(realpath li3ds/.volumes/dev/qtcreator/.config):/root/.config 	\
#             --volumes-from li3ds_ros 											\
# -e NEWUSER=$USER \
docker run 	-it --rm 															\
			--name qtcreator 													\
			-h qtcreator 														\
            -e DISPLAY=$DISPLAY 												\
            -v /tmp/.X11-unix:/tmp/.X11-unix 									\
            --security-opt seccomp=unconfined 									\
            -v $(realpath project/.volumes/dev/qtcreator/.config):/root/.config	\
            project-dev_qtcreator $@