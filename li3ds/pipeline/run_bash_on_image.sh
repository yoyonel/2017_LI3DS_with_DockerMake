#!/bin/bash

source env_for_project.sh $1

echo_i "Build project from: ${GREEN}$PROJECT_IMAGE_TO"

xhost + 
OPTIONS_FOR_QTCREATOR="
			-e DISPLAY=$DISPLAY 												\
            -v /tmp/.X11-unix:/tmp/.X11-unix 									\
            -v $(realpath ../dev/qtcreator/.config):/home/.config 				\
            --security-opt seccomp=unconfined 									\
            "

# Container sur l'image du projet
	docker	run												\
		-it --rm										\
		--name li3ds-prototype_step2					\
		-v $(realpath scripts):/root/scripts			\
		-v /var/run/docker.sock:/var/run/docker.sock	\
		-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws 	\
		-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws 	\
		$OPTIONS_FOR_QTCREATOR							\
		$PROJECT_IMAGE_TO		 						\
		bash

echo_i "${GREEN}${BOLD}Done"