#!/bin/bash

source env_for_project.sh $1

PROJECT_IMAGE_FROM="li3ds-prototype_docker"
PROJECT_IMAGE_TO="$PROJECT_IMAGE_TO_BASE:$PROJECT_SHA256"

# delete image docker for this project
echo_i "Remove docker image: ${GREEN}$PROJECT_IMAGE_TO"
docker rmi $PROJECT_IMAGE_TO

# remove host mountpoints 
./clean_mountpoints.sh

# delete project files (except .rosinstall)
echo_i "Delete project files: ${GREEN}$1"
echo_i "Remove directory: ${GREEN}$1/overlay_ws"
sudo rm -rf $1/overlay_ws
echo_i "Remove file: ${GREEN}$1/sha256.txt"
sudo rm -f $1/sha256.txt