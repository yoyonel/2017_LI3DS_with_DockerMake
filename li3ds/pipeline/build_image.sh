#!/bin/bash

source env_for_project.sh $1

echo_i "Build project from: ${GREEN}$PROJECT_IMAGE_TO"

echo "PATH_TO_OVERLAY_WS_VOLUME: $PATH_TO_OVERLAY_WS_VOLUME"

OPTIONS_FOR_VOLUMES="
        -v $(realpath scripts):/root/scripts			\
		-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws 	\
		-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws 	\
"
#OPTIONS_FOR_VOLUMES="
#    -v overlay:/root/overlay_ws     \
#    -v catkin:/root/catkin_ws       \
#"
OPTIONS_FOR_CPU="
		--cpus=3.0										\
"
# Container sur l'image du projet
# url: https://docs.docker.com/engine/admin/resource_constraints/#kernel-memory-details
docker	run												\
		-it --rm										\
		--name li3ds-prototype_step2					\
        $OPTIONS_FOR_VOLUMES                            \
		$PROJECT_IMAGE_TO		 						\
		build.sh

echo_i "${GREEN}${BOLD}Done"
