#!/bin/bash

source bash_tools.sh

export PROJECT_NAME=$1
#echo_i "Project name: ${RED}$PROJECT_NAME"

export PROJECT_SHA256=$(cat $PROJECT_NAME/sha256.txt)
#echo_i "SHA256 of project: ${RED}$PROJECT_SHA256"

if [ ! -d ../.volumes/pipeline/ ]; then
	mkdir -p ../.volumes/pipeline/
fi
export PATH_TO_VOLUME=$(realpath ../.volumes/pipeline/)
#
export PATH_TO_OVERLAY_WS_VOLUME=$PATH_TO_VOLUME/$PROJECT_SHA256/overlay
export PATH_TO_CATKIN_WS_VOLUME=$PATH_TO_VOLUME/$PROJECT_SHA256/catkin

export PROJECT_IMAGE_TO_BASE="li3ds-prototype"
export PROJECT_IMAGE_TO="$PROJECT_IMAGE_TO_BASE:$PROJECT_SHA256"