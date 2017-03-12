#!/bin/bash

# urls:
# - https://docs.docker.com/engine/reference/commandline/commit/

source env_for_project.sh $1

PROJECT_IMAGE_FROM="li3ds-prototype_docker"
PROJECT_IMAGE_TO="$PROJECT_IMAGE_TO_BASE:$PROJECT_SHA256"

echo_w "Try to create a new image"
echo_w "From:	${RED}$PROJECT_IMAGE_FROM"
echo_w "To:		${RED}$PROJECT_IMAGE_TO"

# Create mountpoints with user right
if [ -d $PATH_TO_CATKIN_WS_VOLUME ]; then
	mkdir -p $PATH_TO_CATKIN_WS_VOLUME
fi
if [ -d $PATH_TO_OVERLAY_WS_VOLUME ]; then
	mkdir -p $PATH_TO_OVERLAY_WS_VOLUME
fi

# # Copying overlay_ws from project to overlay workspace
# echo_i "Copy (host side) overlay workspace ..."
# echo_i "${GREEN}$1/overlay_ws ${CYAN}to ${GREEN}$PATH_TO_OVERLAY_WS_VOLUME/overlay_ws"
# cp $1/overlay_ws $PATH_TO_OVERLAY_WS_VOLUME/overlay_ws

# -v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws \
docker	run 										\
	-it --rm										\
	--name li3ds-prototype_step1					\
	-v /var/run/docker.sock:/var/run/docker.sock	\
	-v $(realpath scripts):/root/scripts 			\
	-v $(realpath $PROJECT_NAME):/root/project 		\
	-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws 	\
	-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws 	\
	-e NEWUSER=$USER 								\
	$PROJECT_IMAGE_FROM 							\
	bash
		
if [ ! $? ]; then
	echo_w "New image created -> ${GREEN}${BOLD}$PROJECT_IMAGE_TO"
fi

echo_i "${GREEN}${BOLD}Done"
