#!/bin/bash

source env_for_project.sh $1

echo_i "Build project from: ${GREEN}$PROJECT_IMAGE_TO"

# Container sur l'image du projet
docker	run												\
		-it --rm										\
		--name li3ds-prototype_step2					\
		-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws 	\
		-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws 	\
		$PROJECT_IMAGE_TO		 						\
		bash -c 'sh /root/build.sh'

echo_i "${GREEN}${BOLD}Done"