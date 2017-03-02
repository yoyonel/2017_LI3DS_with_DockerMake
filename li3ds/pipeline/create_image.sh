#!/bin/bash

# urls:
# - https://docs.docker.com/engine/reference/commandline/commit/

source env_for_project.sh $1

PROJECT_IMAGE_FROM="li3ds-prototype_docker"
PROJECT_IMAGE_TO="$PROJECT_IMAGE_TO_BASE:$PROJECT_SHA256"

echo_w "Try to create a new image"
echo_i "-> from ${RED}$PROJECT_IMAGE_FROM to ${RED}$PROJECT_IMAGE_TO"

docker	run 	\
	-it --rm	\
	--name li3ds-prototype_step1	\
	-v /var/run/docker.sock:/var/run/docker.sock	\
	-v $(realpath $PROJECT_NAME):/root/project/ \
	-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws \
	-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws \
	-e NEWUSER=$USER \
	PROJECT_IMAGE_FROM \
	bash -c \
		'
		cp -r /root/project/overlay_ws /root/.; \
		sh rosdep.sh; \
		sh configure_catkin_ws.sh; \
		PROJECT_SHA256=$(cat /root/project/sha256.txt); \
		docker commit li3ds-prototype_step1 li3ds-prototype:$PROJECT_SHA256
		'

echo_w "New image created"
echo_i "-> ${GREEN}${BOLD}$PROJECT_IMAGE_TO"

echo_i "${GREEN}${BOLD}Done"