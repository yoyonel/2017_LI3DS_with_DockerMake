#!/bin/bash

source bash_tools.sh

export PROJECT_NAME=$1
#echo_i "Project name: ${RED}$PROJECT_NAME"

if [ -d $PROJECT_NAME ]; then
	if [ -d $PROJECT_NAME/.config ]; then
		export PATH_TO_CONFIG=$(realpath $PROJECT_NAME/.config)
		echo_i "PATH_TO_CONFIG: ${GREEN}$PATH_TO_CONFIG"
	fi

	if [ ! -d ../.volumes/pipeline/ ]; then
		mkdir -p ../.volumes/pipeline/
	fi
	export PATH_TO_VOLUME=$(realpath ../.volumes/pipeline/)

	export PROJECT_IMAGE_TO_BASE="li3ds-prototype"

	if [ -f $PROJECT_NAME/sha256.txt ]; then
		export PROJECT_SHA256=$(cat $PROJECT_NAME/sha256.txt)
		#echo_i "SHA256 of project: ${RED}$PROJECT_SHA256"

		#
		export PATH_TO_OVERLAY_WS_VOLUME=$PATH_TO_VOLUME/$PROJECT_SHA256/overlay
		export PATH_TO_CATKIN_WS_VOLUME=$PATH_TO_VOLUME/$PROJECT_SHA256/catkin
		
		export PROJECT_IMAGE_TO="$PROJECT_IMAGE_TO_BASE:$PROJECT_SHA256"
	else
		echo_i "Can't find ${RED}$PROJECT_NAME/sha256.txt"
		echo_i "Need a SHA256 id for the project (see ${GREEN}generate_sha256.sh${CYAN}) "
	fi
fi